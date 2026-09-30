{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "done";
        inherit (pkgs.fishPlugins.done) src;
      }
    ];

    functions = {
      fish_title = {
        body = ''
          set old_status $status
          if [ $old_status != 0 ]
            echo "􀇿 ($old_status)    "
          end
          pwd
        '';
      };
    };

    interactiveShellInit = ''
      set -g fish_greeting

      # Add empty new line after previous outputs, see:
      # https://stackoverflow.com/questions/65722822/fish-shell-add-newline-before-prompt-only-when-previous-output-exists
      function postexec_test --on-event fish_postexec
        echo
      end

      set fish_color_command white --bold
      set fish_color_comment cyan
      set fish_color_param white
      set fish_color_quote magenta
      set fish_color_autosuggestion brblack

      set fish_color_error red
      set fish_color_search_match --background=brblack
      set fish_color_selection --background=yellow

      set fish_pager_color_completion white
      set fish_pager_color_prefix white --bold
      set fish_pager_color_selected_completion brblack
      set fish_pager_color_selected_prefix brblack
      set fish_pager_color_selected_description brblack

      set -U __done_min_cmd_duration 3000
      set -U __done_sway_ignore_visible 1

      ${pkgs.nix-your-shell}/bin/nix-your-shell --nom fish | source
    '';

  };

  home.packages = with pkgs; [
    jq # done plugin dependency
  ];
}
