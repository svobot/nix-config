{ self, ... }:
{
  perSystem =
    { system, ... }:
    {
      apps.neovim = {
        meta.description = "Run neovim customized through nixvim";

        program = "${self.packages.${system}.neovim}/bin/nvim";
      };
    };
}
