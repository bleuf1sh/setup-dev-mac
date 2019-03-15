source ~/.config/fish/bleuf1sh.fish

# terminal stuff
#----------------------------
# Font: Monaco 14pt
# ANSI Colors (normal/bright)
# Black (444444,666565)
# Red (ee5e7c,eb9aab)
# Green (99d899,b1d4b1)
# Yellow (ffd700,f3de6b)
# Blue (52aed9,80c8e8)
# Magenta (e37de3,ec9eec)
# Cyan (76b7bc,a5e1e2)
# White (e9e5e5,ffffff)

# general fish changes
#----------------------------
set -g fish_color_autosuggestion white
set -g fish_color_cancel white
set -g fish_color_command yellow
set -g fish_color_comment white
set -g fish_color_cwd green
set -g fish_color_cwd_root yellow
set -g fish_color_end ff00d7
set -g fish_color_error red
set -g fish_color_escape blue
set -g fish_color_history_current white
set -g fish_color_host white
set -g fish_color_match white
set -g fish_color_normal white
set -g fish_color_operator blue --bold --underline
set -g fish_color_param ffaf00
set -g fish_color_quote ffaf00
set -g fish_color_redirection 00ff00
set -g fish_color_search_match ffff00
set -g fish_color_selection c0c0c0
set -g fish_color_status red
set -g fish_color_user 00ff00
set -g fish_color_valid_path white
set -g fish_pager_color_completion white
set -g fish_pager_color_description B3A06D yellow
set -g fish_pager_color_prefix white --bold --underline
set -g fish_pager_color_progress brwhite --background=cyan 



# bobthefish specific changes
#----------------------------
set -g theme_powerline_fonts no
set -g theme_newline_cursor yes
set -g fish_prompt_pwd_dir_length 0
set -g theme_color_scheme dark


function print_fish_colors --description 'Shows the various fish colors being used'
    set -l clr_list (set -n | grep fish | grep color | grep -v __)
    if test -n "$clr_list"
        set -l bclr (set_color normal)
        set -l bold (set_color --bold)
        printf "\n| %-38s | %-38s |\n" Variable Definition
        echo '|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|'
        for var in $clr_list
            set -l def $$var
            set -l clr (set_color $def ^/dev/null)
            or begin
                printf "| %-38s | %s%-38s$bclr |\n" "$var" (set_color --bold white --background=red) "$def"
                continue
            end
            printf "| $clr%-38s$bclr | $bold%-38s$bclr |\n" "$var" "$def"
        end
        echo '|________________________________________|________________________________________|'\n
    end
end