# nix-config

## Installing a host

Hosts are installed with [nixos-anywhere](https://github.com/nix-community/nixos-anywhere)
from a stock NixOS installer, driven from a machine that already has this repo
and the age master identity at `~/.config/age/agenix-master.age`. The commands
below assume the repo's dev shell and use `neon` as the example host.

Three things have to be prepared by hand, because the configuration cannot
produce them itself: the host's SSH key, its Secure Boot keys and the LUKS
passphrase. The first two go into an `extra` directory that nixos-anywhere
copies into the target root before `nixos-install` runs.

### 1. SSH host key

agenix decrypts every secret on the host, including the root and user password
hashes, with the host's SSH key, so it must exist before the first boot.

For a host that is already in the repo, decrypt the committed key:

```sh
mkdir -p extra/nix/state/etc/ssh
rage -d -i ~/.config/age/agenix-master.age secrets/neon-ssh-host-key.age \
  > extra/nix/state/etc/ssh/ssh_host_ed25519_key
chmod 600 extra/nix/state/etc/ssh/ssh_host_ed25519_key
ssh-keygen -y -f extra/nix/state/etc/ssh/ssh_host_ed25519_key \
  > extra/nix/state/etc/ssh/ssh_host_ed25519_key.pub
```

Check that the printed public key equals `age.rekey.hostPubkey` in the host's
`default.nix`; the rekeyed secrets will not decrypt otherwise.

For a new host, generate the key instead, encrypt the private half to the
master and backup recipients from `modules/nixos/agenix-rekey.nix`, set
`age.rekey.hostPubkey` to the public half, add a `secrets/<host>-root-password.age`
with a `mkpasswd` hash, and run `agenix rekey -a` so the host's rekeyed secrets
are committed:

```sh
ssh-keygen -t ed25519 -N '' -C neon -f extra/nix/state/etc/ssh/ssh_host_ed25519_key
rage -e -r <master pubkey> -r <backup pubkey> \
  -o secrets/neon-ssh-host-key.age extra/nix/state/etc/ssh/ssh_host_ed25519_key
```

### 2. Secure Boot keys

Lanzaboote signs the bootloader during `nixos-install`, which runs in a chroot
where the impermanence bind mounts are not active. The keys therefore have to
be present at both the chroot path and the persisted path:

```sh
sudo sbctl --disable-landlock create-keys \
  -e extra/etc/secureboot/keys -d extra/etc/secureboot/GUID
cp -a extra/etc/secureboot extra/nix/state/etc/secureboot
```

`sbctl` refuses to write outside its default directories unless its landlock
sandbox is disabled, and it needs root. Running it on the booted installer and
copying the result back works as well.

### 3. LUKS passphrase

The host's `disko.nix` sets `passwordFile = "/tmp/disk.key"`, which disko hands
to cryptsetup as a key file. The file contains nothing but the passphrase as it
will be typed at the boot prompt. cryptsetup takes every byte as part of the
key, so it must not end in a newline:

```sh
printf '%s' 'the passphrase' > disk.key
```

### 4. Installer

Boot the target from a NixOS minimal ISO, set a root password with
`sudo passwd root`, note the address from `ip -4 -br addr`, and copy a key over
with `ssh-copy-id root@<address>`. If the target has two interfaces on the same
subnet, bring the one you are not using down first; the installer's reverse
path filter otherwise drops the connection.

### 5. Install

```sh
nix run github:nix-community/nixos-anywhere -- \
  --flake .#neon \
  --disk-encryption-keys /tmp/disk.key ./disk.key \
  --extra-files ./extra \
  root@<address>
```

Add `--phases kexec,disko,install` to leave the machine in the installer
instead of rebooting, for example to inspect the result under `/mnt`.

Afterwards delete `extra` and `disk.key`: they hold the only plaintext copies
of the host key, the Secure Boot private keys and the passphrase.

### 6. First boot

Put the firmware into Secure Boot setup mode (custom mode, then clear the
platform key) so the self-signed bootloader is accepted, boot, and enroll:

```sh
sudo chattr -i /sys/firmware/efi/efivars/KEK-* /sys/firmware/efi/efivars/db-*
sudo sbctl enroll-keys --microsoft
```

Keep `--microsoft`: discrete GPUs carry option ROMs signed by Microsoft's
third-party certificate, and a firmware without it may fail to initialise the
card. The kernel marks EFI variables immutable, hence the `chattr`.

Finally, rebuilding on the host itself needs the PragmataPro archive, which is
not in the repo. Either add it on the host:

```sh
nix-store --add-fixed sha256 PragmataPro0.903.zip
```

or copy the store path from a machine that has it, substituting the host's
address:

```sh
nix copy --to ssh://<host> $(nix eval --raw .#nixosConfigurations.neon.pkgs.pragmata-pro.src)
```
