{
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    settings = {
      add_newline = false;
      directory = {
        style = "bold blue";
      };
      git_status = {
        ahead = "⇡[\${count}](white)";
        diverged = "⇕⇡[\${ahead_count}](white)⇣[\${behind_count}](white)";
        behind = "⇣[\${count}](white)";
      };
    };
  };
}
