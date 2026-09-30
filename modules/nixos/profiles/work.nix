{
  config,
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) self;
  nb = config.services.netbird.clients.work;
  username = "svoboda";
  user = config.users.users.${username};
  workGitconfig = config.age.secrets.work-gitconfig.path;
in
{
  age.secrets = {
    # Holds extra-substituters, extra-trusted-public-keys and netrc-file. Every
    # nix client parses nix.conf and its includes, not just the daemon.
    work-nix-conf = {
      rekeyFile = self + "/secrets/work-nix-conf.age";
      mode = "0444";
    };
    work-netrc.rekeyFile = self + "/secrets/work-netrc.age";
    # Holds ManagementURL. url.URL is serialised field-by-field, so the port
    # lives in Host.
    work-netbird = {
      rekeyFile = self + "/secrets/work-netbird.age";
      path = "/etc/${nb.dir.baseName}/config.d/60-management.json";
      owner = nb.user.name;
      group = nb.user.group;
    };
    work-gitconfig = {
      rekeyFile = self + "/secrets/work-gitconfig.age";
      owner = user.name;
    };
    work-kolide = {
      rekeyFile = self + "/secrets/work-kolide.age";
      path = "${config.services.kolide-launcher.enrollSecretDirectory}/secret";
    };
  };

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    daemon.settings.features.buildkit = true;
    extraPackages = with pkgs; [ openssh ];
  };

  environment.systemPackages = with pkgs; [
    claude-code
    (t3code.override { enableCodex = false; })
  ];

  environment.persistence."/nix/state".directories = [
    "/var/kolide-k2"
    "/var/lib/docker"
    {
      directory = nb.dir.state;
      user = nb.user.name;
      group = nb.user.group;
      mode = "0700";
    }
  ];

  home-manager.users.${username} =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.git = {
        maintenance.enable = true;
        # The registered repositories live outside the repo; maintain the list
        # with `git maintenance register --config-file /nix/state/work/gitconfig`.
        includes = [
          { path = "/nix/state/work/gitconfig"; }
          {
            condition = "gitdir:${config.home.homeDirectory}/dev/work/";
            path = workGitconfig;
          }
        ];
      };

      # Prefetch needs the network. A failed ExecCondition skips the run instead
      # of failing the unit, so being offline doesn't page through OnFailure.
      # The check itself talks netlink, which home-manager's hardening excludes.
      systemd.user.services."git-maintenance@".Service = {
        ExecCondition = "${pkgs.systemd}/lib/systemd/systemd-networkd-wait-online --any --timeout=1 --quiet";
        RestrictAddressFamilies = lib.mkForce "AF_UNIX AF_INET AF_INET6 AF_VSOCK AF_NETLINK";
      };
    };

  nix.extraOptions = "!include ${config.age.secrets.work-nix-conf.path}";

  services = {
    netbird.clients.work = {
      port = 51820;
      # netbird >=0.78 maps NB_CONFIG onto the --config flag, deprecated on
      # every subcommand but `service run`; only the daemon needs the path,
      # so it moves to the unit below instead of the shared CLI wrapper
      environment = lib.mkForce {
        NB_DAEMON_ADDR = "unix://${nb.dir.runtime}/sock";
        NB_INTERFACE_NAME = nb.interface;
        NB_LOG_FILE = "console";
        NB_LOG_LEVEL = nb.logLevel;
        NB_SERVICE = nb.service.name;
        NB_STATE_DIR = nb.dir.state;
        NB_WIREGUARD_PORT = toString nb.port;
      };
      # nil is treated as enabled, which makes the daemon refuse an
      # unprivileged `up -m` (GHSA-qcpp-8vwj-hhwr)
      config.ServerSSHAllowed = false;
    };

    kolide-launcher = {
      enable = true;
      autoupdateInterval = "90000h";
      autoupdaterInitialDelay = "90000h";
    };
  };

  systemd.services = {
    ${nb.service.name}.environment.NB_CONFIG = "${nb.dir.state}/config.json";
    # nix.conf only references the include, so a changed secret alone would
    # not restart the daemon.
    nix-daemon.restartTriggers = [ config.age.secrets.work-nix-conf.file ];
  };

  # `git config --file` writes through a lock file next to its target, so the
  # directory has to be writable, not just the file.
  systemd.tmpfiles.settings."10-work-git"."/nix/state/work".d = {
    user = user.name;
    inherit (user) group;
    mode = "0700";
  };
}
