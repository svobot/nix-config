final: _: {
  firefox-ui-fix = final.callPackage (
    {
      lib,
      fetchFromGitHub,
      fetchpatch,
      stdenv,
    }:
    stdenv.mkDerivation rec {
      pname = "firefox-ui-fix";
      version = "8.7.6";

      src = fetchFromGitHub {
        owner = "black7375";
        repo = "Firefox-UI-Fix";
        rev = "v${version}";
        sha256 = "sha256-YT+MauszyRyo38hSVdr3I11CR1Iz6FvetAkJuPlbt6k=";
      };

      patches = [
        # https://github.com/black7375/Firefox-UI-Fix/pull/1193
        (fetchpatch {
          url = "https://github.com/black7375/Firefox-UI-Fix/commit/2fb1bd4e6d012e29a519c0fa0f5ba44931a90ea8.patch";
          hash = "sha256-nMCkVlFyY7vRG1QYweIMuBRsuEBsWn7lFZY5gbXuwNQ=";
        })
      ];

      # The PR predates v8.7.6, so hunks land with offset/fuzz; without this
      # `patch` drops .orig backups next to the css it installs.
      patchFlags = [
        "-p1"
        "--no-backup-if-mismatch"
      ];

      installPhase = ''
        mkdir -p $out/chrome
        cp -t $out/ CREDITS LICENSE user.js
        cp -R ./{css,icons} $out/chrome
      '';

      meta = with lib; {
        license = with licenses; [ mpl20 ];
        platforms = platforms.all;
      };
    }
  ) { };
}
