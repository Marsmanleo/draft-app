# draft-shell-integration (fish)
# Emits OSC 7 (cwd) + OSC 133 A/B/C/D so the host tracks cwd and prompt
# boundaries without re-parsing the prompt. fish 4.0+ writes its own OSC 133
# A/B (the `mark-prompt` feature); Draft disables it at spawn via
# fish_features=no-mark-prompt so these markers aren't emitted twice.

# Installed into conf.d, which every fish session sources; only Draft-spawned
# shells (DRAFT_TERMINAL=1) may get their prompt wrapped.
if not set -q DRAFT_TERMINAL
    exit 0
end
if set -q __DRAFT_HOOKS_LOADED
    exit 0
end
set -g __DRAFT_HOOKS_LOADED 1

# Draft is a clean terminal; drop fish's default startup greeting. A user who
# sets their own in config.fish (sourced after this) keeps it.
function fish_greeting
end

set -g __DRAFT_HOST (uname -n 2>/dev/null; or echo localhost)

# URL-encode a path keeping `/` intact so it stays valid inside file://.
function __draft_urlencode_path
    set -l parts (string split '/' -- $argv[1])
    set -l out
    for p in $parts
        if test -n "$p"
            set out $out (string escape --style=url -- $p)
        else
            set out $out ""
        end
    end
    string join '/' $out
end

function __draft_restore_status
    return $argv[1]
end

if functions -q fish_prompt
    functions -c fish_prompt __draft_user_prompt
end

# Wrapped so `fish -C __draft_install_prompt` can re-run it in block mode AFTER
# config.fish, where a framework prompt (starship etc.) would otherwise override
# fish_prompt and drop our markers.
function __draft_install_prompt
    if set -q DRAFT_BLOCKS
        function fish_right_prompt
        end
        function fish_greeting
        end
    end
    function fish_prompt
        set -l __draft_status $status
        printf '\e]133;D;%d\e\\' $__draft_status
        printf '\e]7;file://%s%s\e\\' "$__DRAFT_HOST" (__draft_urlencode_path "$PWD")
        printf '\e]133;A\e\\'
        # Block mode: host renders its own input bar, so suppress the shell prompt
        # (B marker only) and reserve header/gap rows, mirroring zsh.
        if set -q DRAFT_BLOCKS
            if set -q __draft_block_seen
                printf '\n\n'
            else
                printf '\n'
            end
            printf '\e]133;B\e\\'
            return
        end
        __draft_restore_status $__draft_status
        if functions -q __draft_user_prompt
            __draft_user_prompt
        else
            printf '%s > ' (prompt_pwd)
        end
        printf '\e]133;B\e\\'
    end
end
__draft_install_prompt

function __draft_preexec --on-event fish_preexec
    set -g __draft_block_seen 1
    set -l cmd (string replace -ra '[\x00-\x1f\x7f]' ' ' -- "$argv")
    printf '\e]133;C;%s\e\\' (string sub -l 256 -- "$cmd")
end
