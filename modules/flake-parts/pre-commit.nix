# Pre-commit hooks configuration
{
  perSystem.pre-commit = {
    check.enable = true;
    settings.hooks = {
      actionlint.enable = true;
      check-added-large-files.enable = true;
      check-merge-conflicts.enable = true;
      check-symlinks.enable = true;
      convco.enable = true;
      deadnix.enable = true;
      end-of-file-fixer = {
        enable = true;
        excludes = [ "\\.patch$" ];
      };
      nil.enable = true;
      ripsecrets.enable = true;
      shellcheck.enable = true;
      statix.enable = true;
      treefmt.enable = true;
      # Whitespace-only context lines in patches are significant.
      trim-trailing-whitespace = {
        enable = true;
        excludes = [ "\\.patch$" ];
      };
      zizmor.enable = true;
    };
  };
}
