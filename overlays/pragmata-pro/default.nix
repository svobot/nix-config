final: _: {
  pragmata-pro =
    let
      version = "0.903";
    in
    final.runCommand "pragmata-pro-${version}"
      {
        buildInputs = [ final.unzip ];
        #src = final.copyPathToStore "${toString ./.}/PragmataPro${version}.zip";
        src = final.requireFile rec {
          name = "PragmataPro${version}.zip";
          url = "file://${name}";
          sha256 = "0l5kndr4y7chxj8av0jdqq1sa7rglh4jqr5ifh6whhpb7jz0z0bz";
          message = ''
            ${name} font not found in nix store, to add it run:
              $ nix-store --add-fixed sha256 file://${name}
            Calculate the sha256 with:
              $ nix-hash --flat --base32 --type sha256 /path/to/${name}'';
        };
      }
      ''
        mkdir -p $out/share/fonts/truetype
        unzip -jo $src \*.ttf -d $out/share/fonts/truetype
      '';
}
