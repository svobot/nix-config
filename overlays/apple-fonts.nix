final: _:
let
  common =
    {
      stdenv,
      fetchurl,
      p7zip,
      cpio,
      name ? "",
      fontName ? "",
      sha256 ? "",
      ...
    }:
    stdenv.mkDerivation rec {
      inherit name fontName;
      src = fetchurl {
        url = "https://devimages-cdn.apple.com/design/resources/download/${name}.dmg";
        inherit sha256;
      };

      nativeBuildInputs = [
        p7zip
        cpio
      ];
      unpackPhase = "7z x ${src}";

      buildPhase = ''
        if [ ! -e Payload~ ]; then
          cd "$( echo "${fontName}" | tr -d "[:space:]" )"
          7z x "${fontName}.pkg"
        fi
        cpio -idm --quiet < Payload~ && cd ./Library/Fonts/
      '';

      installPhase = ''mkdir -p $out/share/fonts/opentype/ && cp * "$_"'';
    };
in
{
  apple-sf-pro = final.callPackage common {
    name = "SF-Pro";
    fontName = "SF Pro Fonts";
    sha256 = "sha256-loqzuLH5LC2K9h6waA9cIiTE541ZuYa/AEUCp/wBKRg=";
  };
  apple-sf-compact = final.callPackage common {
    name = "SF-Compact";
    fontName = "SF Compact Fonts";
    sha256 = "sha256-wdDjROut1m62LwP4I3hMzknxeH9WVj+wmPygH8VUE1w=";
  };
  apple-sf-mono = final.callPackage common {
    name = "SF-Mono";
    fontName = "SF Mono Fonts";
    sha256 = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
  };
  apple-sf-arabic = final.callPackage common {
    name = "SF-Arabic";
    fontName = "SF Arabic Fonts";
    sha256 = "sha256-J2DGLVArdwEsSVF8LqOS7C1MZH/gYJhckn30jRBRl7k=";
  };
}
