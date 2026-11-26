function float --description 'Float this Rex pane at 80 columns in the top right and focus another tiled pane if available'
    if not set -q REX_SESSION[1] REX_BLOCK[1]
        printf '%s\n' 'float: Run this function in a Rex pane.' >&2
        return 1
    end

    for tool in rex jq
        if not command -sq $tool
            printf 'float: %s is required.\n' $tool >&2
            return 1
        end
    end

    set -l view (command rex api call -s "$REX_SESSION" session.view)
    or return

    set -l context (printf '%s\n' $view | command jq -ce --arg block "$REX_BLOCK" '
        first(.windows[]? | select(any(.layers[].blocks[]?; .block_id == $block)))
        // error("The current pane was not found.")
        | . as $window
        | first(.layers[] | select(.kind == "tiled")) as $tiled
        | first(.layers[] | select(any(.blocks[]?; .block_id == $block))) as $layer
        | [$tiled.blocks[]? | select(.block_id != $block)] as $others
        | if $layer.kind == "floating" and ($layer.blocks | length) != 1 then
            error("The floating layer contains more than one pane.")
          else . end
        | first($layer.layout | .. | objects | select(.block_id? == $block)) as $node
        | (if $window.zoomed_block_id == $block then
            {block_id: $block, rect: [0, 0, 1, 1]}
          else
            ([$tiled.layout | .. | objects | select(.block_id? != null)
                | . as $candidate
                | select(any($tiled.blocks[]?;
                    .block_id == $candidate.block_id and .creator_name == "com.superlogical.terminal"))
                | {block_id, rect}]
                | max_by(.rect[2] * .rect[3]))
            // {block_id: $block, rect: $node.rect}
          end) as $measurement
        | [$tiled.layout | .. | objects | .split? // empty
            | select(.before.block_id? == $block or .after.block_id? == $block)][0] as $parent
        | (if $parent then
            (if $parent.before.block_id? == $block then "before" else "after" end) as $side
            | (if $side == "before" then $parent.after else $parent.before end) as $sibling
            | {
                anchor_id: ($sibling.block_id // $sibling.split.split_id),
                direction: $parent.direction,
                side: $side,
                ratio: $parent.ratio
              }
          else null end) as $restore
        | {
            kind: $layer.kind,
            layer_id: $layer.layer_id,
            measurement: $measurement,
            focus_block_id: $others[0].block_id,
            restore: $restore
          }
    ')
    or return

    set -l measurement_block (printf '%s\n' "$context" | command jq -er '.measurement.block_id')
    or return
    set -l pane_size (command rex block call -s "$REX_SESSION" -b "$measurement_block" size)
    or return

    set -l request (command jq -cen --arg block "$REX_BLOCK" \
        --argjson context "$context" --argjson size "$pane_size" '
        if $size.columns <= 0 or $size.rows <= 0 then
            error("The terminal size is not available.")
        else
            {right: 0.0133783191382765, top: 0.03334318974103586,
                columns: 196, rows: 53,
                floating_width: 0.4159308199732799, floating_columns: 80} as $reference
            | ($context.measurement.rect[2] / $size.columns) as $cell_width
            | ($reference.floating_width * $reference.columns - $reference.floating_columns) as $frame_columns
            | ((80 + $frame_columns) * $cell_width) as $width
            | ($reference.right * $reference.columns * $cell_width) as $inset_x
            | ($reference.top * $reference.rows * $context.measurement.rect[3] / $size.rows) as $inset_y
            | [1 - $width - $inset_x, $inset_y, $width, (1 / 3)] as $bounds
            | if $bounds[0] < 0 or $inset_y + (1 / 3) > 1 then
                error("The window is too small for an 80-column terminal.")
              elif $context.kind == "tiled" then
                {block_id: $block, bounds: $bounds}
              else
                {layer_id: $context.layer_id, bounds: $bounds}
              end
        end
    ')
    or return

    set -l kind (printf '%s\n' "$context" | command jq -r '.kind')
    if test "$kind" = tiled
        set -l restore (printf '%s\n' "$context" | command jq -ce \
            --arg session "$REX_SESSION" --arg block "$REX_BLOCK" \
            '.restore + {session_id: $session, block_id: $block}')
        or return

        command rex api call -s "$REX_SESSION" session.float_block "$request" >/dev/null
        or return
        set -g __rex_float_restore "$restore"
    else
        command rex api call -s "$REX_SESSION" session.resize_layer "$request" >/dev/null
        or return
    end

    set -l target (printf '%s\n' "$context" | command jq -r '.focus_block_id // empty')
    if not set -q target[1]
        return 0
    end
    command rex focus -s "$REX_SESSION" "$target"
end
