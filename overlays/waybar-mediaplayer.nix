final: _: {
  waybar-mediaplayer = final.callPackage (
    {
      lib,
      stdenv,
      glib,
      gobject-introspection,
      playerctl,
      python3,
      waybar,
      wrapGAppsHook3,
    }:

    stdenv.mkDerivation rec {
      pname = "waybar-mediaplayer";
      inherit (waybar) version src;

      dontBuild = true;
      dontConfigure = true;

      strictDeps = true;
      nativeBuildInputs = [
        gobject-introspection
        wrapGAppsHook3
      ];

      propagatedBuildInputs = [
        glib
        playerctl
        python3.pkgs.pygobject3
      ];

      installPhase = ''
        mkdir -p $out/bin
        substitute $src/resources/custom_modules/mediaplayer.py $out/bin/waybar-mediaplayer.py \
          --replace-fail '' '􀊘' \
          --replace-fail ' ' ""
        chmod +x $out/bin/waybar-mediaplayer.py
        wrapProgram $out/bin/waybar-mediaplayer.py \
          --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3.sitePackages}"
      '';

      doInstallCheck = true;

      installCheckPhase = ''
        if $out/bin/waybar-mediaplayer.py --help >/dev/null; then
          echo "waybar-mediaplayer --help passed"
        fi
      '';

      meta = waybar.meta // {
        description = "A media player module based on playerctl for Waybar";
        homepage = "https://github.com/Alexays/Waybar/tree/${version}/resources/custom_modules";
        platforms = lib.platforms.linux;
      };
    }
  ) { };
}
