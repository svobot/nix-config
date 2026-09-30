{ inputs, self, ... }:
{
  imports = [ inputs.agenix-rekey.flakeModule ];

  perSystem.agenix-rekey.nixosConfigurations = self.nixosConfigurations;
}
