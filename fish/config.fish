set BROWSER /bin/firefox

abbr b bat
abbr r ranger
abbr rm echo\x20\x22Did\x20you\x20mean\x20trash\x20\x28t\x29\x3f\x3b\x20false
abbr t trash
abbr v nvim
abbr g git
abbr d doas
abbr ls exa

set fish_cursor_unknown block

function jl
	jq -C | less -R
end
