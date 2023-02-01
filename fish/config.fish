set BROWSER /bin/firefox
set _fish_abbr_b bat
set _fish_abbr_r ranger
set _fish_abbr_rm echo\x20\x22Did\x20you\x20mean\x20trash\x20\x28t\x29\x3f\x3b\x20false
set _fish_abbr_t trash
set _fish_abbr_v nvim

set fish_key_bindings fish_vi_key_bindings
set fish_cursor_unknown block

function jl
	jq -C | less -R
end
