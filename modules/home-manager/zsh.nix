{ pkgs, inputs, ... }: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    history.path = "$HOME/.hf";
    history.save = 10000;
    history.size = 10000;
    history.share = true;
    history.extended = true;
    history.ignoreSpace = true;

    completionInit = ''
      zstyle :compinstall filename '/home/rick-topl/.config/zsh/.zshrc'
      zstyle ':vcs_info:git:*' formats '[%b]'
      autoload -Uz compinit
      autoload -U colors && colors
      autoload -Uz vcs_info
      precmd() {vcs_info}
      compinit
    '';

    shellAliases = {
      ls = "ls -h --color=auto --group-directories-first";
      ll = "ls -alF";
      l = "ls -A";
      la = "ls -CF --color=auto";
      less = "less -R";
      watch = "watch --color";
      sudoe = "sudo -E -s";
      pingt = "ping -c 5 google.com";
      pingd = "ping -c 5 8.8.8.8";
      gitlog =
        "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      gitlines = "git ls-files | xargs wc -l";
      dirsize = "du -sh $PWD/*";
      nixbuild =
        ''sudo nixos-rebuild switch --flake "/home/rick-topl/.config/nixos#"'';
      n = "nvim";
      k = "kubectl";
      pc = "podman-compose";
      kpods = "kubectl get pods --all-namespaces | grep -v 'kube-system'";
      kbox = "kubectl run temp-pod --rm -i --tty --image=busybox -- /bin/sh";
      nixconf = "~nixconf";
      cat = "bat --paging=never";
    };

    sessionVariables = {
      LANG = "en_US.UTF-8";
      TERM = "kitty";
      EDITOR = "nvim";
      PATH = "~/.npm-packages/bin:$PATH";
      NODE_PATH = "~/.npm-packages/lib/node_modules";
      RPROMPT = "%F{57}\${vcs_info_msg_0_}%f%b";
      DIRENV_LOG_FORMAT = "";
      READNULLCMD = "bat_read_null";
      BAT_THEME = "Solarized (dark)";
    };

    initExtra = ''
      setopt extendedglob nomatch
      setopt EXTENDED_HISTORY
      setopt INC_APPEND_HISTORY
      setopt HIST_FIND_NO_DUPS
      unsetopt beep
      bindkey -v
      bindkey -r '^W'
      REPORTTIME=20
      setopt +o nomatch
      setopt PROMPT_SUBST
      export KEYTIMEOUT=1
      bat_read_null() { bat --paging=never };

      PS1='%T%F{33}|%n%{$reset_color%}@%F{13}%m|%f%{$fg[green]%}%~%{$reset_color%}%{$fg[white]%}''${vim_mode}%'


      vim_ins_mode="%{$fg[green]%}|%{$reset_color%}"
      vim_cmd_mode="%{$fg[red]%}|%{$reset_color%}"
      vim_mode=$vim_ins_mode

      function zle-keymap-select {
        vim_mode="''${''${KEYMAP/vicmd/''${vim_cmd_mode}}/(main|viins)/''${vim_ins_mode}}"
      zle reset-prompt
      }

      function zle-line-finish {
        vim_mode=$vim_ins_mode
      }

      zle -N zle-line-finish
      zle -N zle-keymap-select

      # echo -e "\e[1;35m$(figlet 'Hack the Planet')\e[0m"

      eval "$(direnv hook zsh)"
    '';
    dirHashes = {
      dl = "$HOME/Downloads";
      nixconf = "$HOME/.config/nixos";
      bins = "$HOME/bins";
    };
  };
}
