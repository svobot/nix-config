{ config, ... }:
{
  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
      };
    };
    git = {
      enable = true;
      settings = {
        user = {
          name = "Tomáš Svoboda";
          email = "svoboda@posteo.net";
        };
        branch.sort = "-committerdate";
        commit = {
          gpgSign = true;
          verbose = true;
        };
        credential.helper = "cache";
        diff.algorithm = "histogram";
        github.user = "svobot";
        gpg.format = "ssh";
        init.defaultBranch = "main";
        maintenance.strategy = "incremental";
        merge.conflictstyle = "zdiff3";
        tag.gpgSign = true;
        user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        push.default = "current";
        rebase = {
          autosquash = true;
          autostash = true;
        };
        rerere = {
          autoupdate = true;
          enabled = true;
        };
      };
      signing.format = "ssh"; # TODO: As of 25.05, I think this is superfluous.
    };
  };

  home.shellAliases = rec {
    g = "git";
    ga = "git add";
    gaa = "${ga} -A";
    gb = "git branch";
    gch = "git checkout";
    gcl = "git clone";
    gco = "git commit";
    gcof = "${gco} --fixup";
    gcom = "${gco} --message";
    gcoa = "${gco} --amend";
    gcoan = "${gcoa} --no-edit";
    gdf = "git diff";
    gdfs = "${gdf} --staged";
    gdt = "git difftool";
    gdts = "${gdt} --staged";
    gf = "git fetch --all --prune --tags";
    gfpl = "${gf} && ${gpl}";
    gff = "${gf} --force";
    gl = "git log --decorate --pretty=format:'%C(auto)%h %C(green)(%as)%C(reset)%C(blue) %<(20,trunc) %an%C(reset) %s%C(auto)%d'";
    gm = "git merge";
    gma = "${gm} --abort";
    gmc = "${gm} --continue";
    gpl = "git pull --rebase";
    gps = "git push";
    gpsf = "git push --force-with-lease";
    grb = "git rebase";
    grba = "${grb} --abort";
    grbc = "${grb} --continue";
    grbsn = "${grb} --exec 'git commit --amend --no-edit -n -S'";
    grs = "git restore";
    grss = "${grs} --staged";
    gs = "git status --short";
  };
}
