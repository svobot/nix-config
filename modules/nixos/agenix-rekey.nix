{
  config,
  flake,
  lib,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [ inputs.agenix-rekey.nixosModules.default ];

  age.rekey = {
    # agenix-rekey splices the identity into its scripts verbatim, so the quotes
    # keep $HOME unexpanded until run time; the pubkey lets encryption skip
    # decrypting the passphrase-protected identity.
    masterIdentities = [
      {
        identity = ''"$HOME/.config/age/agenix-master.age"'';
        pubkey = "age18l75zxwxtwqzrh7vm4zyc5wvrq7lumlkfj2ar2z7n2l8th0m99uqvead32";
      }
    ];
    # Offline backup, kept on paper.
    extraEncryptionPubkeys = [ "age1rk0qyt6q2f8v90rwujxx33pdd6zltpkgk3r4fkca89q4dzl8y3ks5wpyhd" ];

    storageMode = "local";
    localStorageDir = lib.mkDefault (self + "/secrets/rekeyed/${config.networking.hostName}");
  };
}
