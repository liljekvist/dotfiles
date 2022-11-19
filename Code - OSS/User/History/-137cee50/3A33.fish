
    ## Set values
    # Hide welcome message
    set fish_greeting
    set VIRTUAL_ENV_DISABLE_PROMPT "1"
    set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

    # Set settings for https://github.com/franciscolourenco/done
    set -U __done_min_cmd_duration 10000
    set -U __done_notification_urgency_level low


    ## Environment setup
    # Apply .profile
    source ~/.profile

    set -Ux XDG_RUNTIME_DIR /tmp
    set GTK_THEME "Catppuccin-Mocha-Mauve"
    set -Ux SDL_VIDEODRIVER wayland
    set -Ux LIBVA_DRIVER_NAME nvidia
    set -Ux XDG_SESSION_TYPE wayland
    set -Ux GBM_BACKEND nvidia-drm
    set -Ux __GLX_VENDOR_LIBRARY_NAME nvidia
    set -Ux WLR_NO_HARDWARE_CURSORS 1
    set -Ux EDITOR code   
    set -Ux VISUAL code
    set -Ux QT_QPA_PLATFORMTHEME qt5ct 
    set -Ux BAT_THEME "Catppuccin-mocha"
    set -Ux GDK_CORE_DEVICE_EVENTS 1
    set -Ux GDK_BACKEND wayland

    set -Ux PATH /home/liljekvist/.local/bin:$PATH

    set -Ux FZF_DEFAULT_OPTS " \
--color=bg+:-1,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#a6e3a1,prompt:#cba6f7,hl+:#f38ba8"


    # Add ~/.local/bin to PATH
    if test -d ~/.local/bin
        if not contains -- ~/.local/bin $PATH
            set -p PATH ~/.local/bin
        end
    end


    ## Starship prompt
    if status --is-interactive
        source ("/usr/bin/starship" init fish --print-full-init | psub)
    end


    ## Functions
    # Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
    function __history_previous_command
    switch (commandline -t)
    case "!"
        commandline -t $history[1]; commandline -f repaint
    case "*"
        commandline -i !
    end
    end

    function __history_previous_command_arguments
    switch (commandline -t)
    case "!"
        commandline -t ""
        commandline -f history-token-search-backward
    case "*"
        commandline -i '$'
    end
    end

    if [ "$fish_key_bindings" = fish_vi_key_bindings ];
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
    else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
    end

    # Fish command history
    function history
        builtin history --show-time='%F %T '
    end

    function backup --argument filename
        cp $filename $filename.bak
    end

    # Copy DIR1 DIR2
    function copy
        set count (count $argv | tr -d \n)
        if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
            command cp -r $from $to
        else
            command cp $argv
        end
    end

    ## Import colorscheme from 'wal' asynchronously
    if type "wal" >> /dev/null 2>&1
    cat ~/.cache/wal/sequences
    end

    ## Useful aliases
    # Replace ls with exa
    alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
    alias la='exa -a --color=always --group-directories-first --icons'  # all files and dirs
    alias ll='exa -l --color=always --group-directories-first --icons'  # long format
    alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
    alias l.="exa -a | egrep '^\.'"                                     # show only dotfiles

    # Replace some more things with better alternatives
    alias cat='bat --style header --style rules --style snip --style changes --style header'
    [ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru --bottomup'


    alias grubup="sudo update-grub"
    alias tarnow='tar -acf '
    alias untar='tar -zxvf '
    alias wget='wget -c '
    alias ..='cd ..'
    alias ...='cd ../..'
    alias ....='cd ../../..'
    alias .....='cd ../../../..'
    alias ......='cd ../../../../..'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias hw='hwinfo --short'                                   # Hardware Info
    alias n='nvim -O'


    # Get the error messages from journalctl
    alias jctl="journalctl -p 3 -xb"

    ## Run paleofetch if session is interactive
    if status --is-interactive
    neofetch
    end

