# CI workflow definitions, rendered to .github/workflows by actions-nix
{ inputs, ... }:
let
  actions = {
    cache = "actions/cache@55cc8345863c7cc4c66a329aec7e433d2d1c52a9"; # v6.1.0
    checkout = "actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1"; # v7.0.1
    nix-installer = "DeterminateSystems/nix-installer-action@3138316df39ed29be04236d7ffc686fa525866aa"; # v23
  };

  # actions/checkout makes a depth-1 clone, from which nix cannot compute revCount.
  flakeRef = "git+file:.?shallow=1";
in
{
  imports = [ inputs.actions-nix.flakeModules.default ];

  flake.actions-nix = {
    pre-commit.enable = true;

    defaultValues.jobs = {
      timeout-minutes = 60;
      runs-on = "ubuntu-24.04";
    };

    workflows.".github/workflows/ci.yaml" = {
      name = "ci";

      on = {
        push.branches = [ "main" ];
        pull_request = { };
        workflow_dispatch = { };
      };

      concurrency = {
        group = "ci-\${{ github.head_ref || github.ref_name }}";
        cancel-in-progress = "\${{ github.event_name == 'pull_request' }}";
      };

      permissions = { };

      # Evaluation only: pragmata-pro is a requireFile that exists only on the
      # workstations, so the hosts themselves cannot be built here.
      jobs.flake-check = {
        name = "flake check";
        steps = [
          {
            uses = actions.checkout;
            "with".persist-credentials = false;
          }
          {
            uses = actions.nix-installer;
            "with".determinate = false;
          }
          {
            uses = actions.cache;
            "with" = {
              path = "~/.cache/nix";
              key = "nix-eval-\${{ runner.os }}-\${{ hashFiles('flake.lock') }}";
              restore-keys = "nix-eval-\${{ runner.os }}-";
            };
          }
          {
            name = "nix flake check";
            run = "nix flake check '${flakeRef}'";
          }
          {
            name = "nix flake show";
            run = "nix flake show '${flakeRef}'";
          }
        ];
      };
    };
  };
}
