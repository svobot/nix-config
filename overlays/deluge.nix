# deluge 2.2.0 still imports `pkg_resources`, which was removed in
# setuptools 81. Swap in the last release that ships it until upstream
# fixes it. See https://github.com/NixOS/nixpkgs/issues/540545
final: prev:
let
  withSetuptools80 =
    pkg:
    pkg.overrideAttrs (old: {
      propagatedBuildInputs = map (
        p: if (p.pname or "") == "setuptools" then final.python3Packages.setuptools_80 else p
      ) (old.propagatedBuildInputs or [ ]);
    });
in
{
  deluge-gtk = withSetuptools80 prev.deluge-gtk;
  deluged = withSetuptools80 prev.deluged;
  deluge = final.deluge-gtk;
}
