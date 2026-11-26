function unfloat --description 'Return this Rex pane to its saved tiled position'
    if not set -q REX_SESSION[1] REX_BLOCK[1]
        printf '%s\n' 'unfloat: Run this function in a Rex pane.' >&2
        return 1
    end

    for tool in rex jq
        if not command -sq $tool
            printf 'unfloat: %s is required.\n' $tool >&2
            return 1
        end
    end

    set -l view (command rex api call -s "$REX_SESSION" session.view)
    or return

    set -l saved '{}'
    if set -q __rex_float_restore[1]
        set saved "$__rex_float_restore"
    end

    set -l restore (printf '%s\n' $view | command jq -ce \
        --arg session "$REX_SESSION" --arg block "$REX_BLOCK" --argjson saved "$saved" '
        first(.windows[]? | select(any(.layers[].blocks[]?; .block_id == $block)))
        // error("The current pane was not found.")
        | first(.layers[] | select(.kind == "tiled")) as $tiled
        | first(.layers[] | select(any(.blocks[]?; .block_id == $block))) as $layer
        | if $layer.kind != "floating" then
            error("The current pane is already tiled.")
          elif ($tiled.blocks | length) == 0 then
            error("A tiled pane is required to restore this pane.")
          else . end
        | if $saved.session_id == $session and $saved.block_id == $block
            and ($saved.anchor_id != null)
            and any($tiled.layout | .. | objects;
                .block_id? == $saved.anchor_id or .split.split_id? == $saved.anchor_id)
          then $saved
          else {
            block_id: $block,
            anchor_id: $tiled.blocks[0].block_id,
            direction: "horizontal",
            side: "after",
            ratio: 0.5
          } end
    ')
    or return

    set -l anchor (printf '%s\n' "$restore" | command jq -r '.anchor_id')
    if string match -q 'split:*' -- "$anchor"
        set -l request (printf '%s\n' "$restore" | command jq -c '{
            anchor_id, direction, side, ratio,
            layout: {block: {flavor: "com.superlogical.terminal.shell"}},
            focus: false
        }')
        or return

        set -l created (command rex api call -s "$REX_SESSION" session.new_split "$request")
        or return
        set -l placeholder (printf '%s\n' $created | command jq -er '.block_ids[0]')
        or return

        if not command rex swap -s "$REX_SESSION" "$REX_BLOCK" "$placeholder"
            command rex block close -s "$REX_SESSION" "$placeholder"
            return 1
        end
        set -e __rex_float_restore
        command rex block close -s "$REX_SESSION" "$placeholder"
        or return
    else
        set -l request (printf '%s\n' "$restore" | command jq -c '{
            block_id, anchor_block_id: .anchor_id, direction, side, ratio
        }')
        or return

        command rex api call -s "$REX_SESSION" session.move_block "$request" >/dev/null
        or return
        set -e __rex_float_restore
    end

    command rex focus -s "$REX_SESSION" "$REX_BLOCK"
end
