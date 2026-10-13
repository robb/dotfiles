function push --description "Send a push notification via push.robb.systems."
    argparse 'h/help' 't/to=' 'b/body=' 'l/lang=' 'd/dir=' 'n/navigate=' -- $argv
    or return 1

    if set -q _flag_help; or test (count $argv) -ne 1
        echo "usage: push [-t to] [-b body] [-l lang] [-d ltr|rtl] [-n url] <title>" >&2
        return 1
    end

    if test -z "$PUSH_TOKEN"
        echo "push: PUSH_TOKEN is not set" >&2
        return 1
    end

    set -q _flag_to; or set -l _flag_to all

    jq -n \
        --arg token "$PUSH_TOKEN" \
        --arg to "$_flag_to" \
        --arg title "$argv[1]" \
        --arg body "$_flag_body" \
        --arg lang "$_flag_lang" \
        --arg dir "$_flag_dir" \
        --arg navigate "$_flag_navigate" \
        '{$token, $to, $title, $body, $lang, $dir, $navigate} | with_entries(select(.value != ""))' \
    | curl -fsS -X POST https://push.robb.systems/send \
        -H 'Content-Type: application/json' \
        --data-binary @-
end
