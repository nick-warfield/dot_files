SETUVAR BROWSER:/bin/firefox
SETUVAR _fish_abbr_b:bat
SETUVAR _fish_abbr_r:ranger
SETUVAR _fish_abbr_rm:echo\x20\x22Did\x20you\x20mean\x20trash\x20\x28t\x29\x3f\x3b\x20false
SETUVAR _fish_abbr_t:trash
SETUVAR _fish_abbr_v:nvim

SETUVAR fish_key_bindings:fish_vi_key_bindings
SETUVAR fish_cursor_unknown:block

function jl
	jq -C | less -R
end
