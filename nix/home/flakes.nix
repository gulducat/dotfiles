{ inputs, pkgs, ... }:
{
  home.packages = [
      inputs.crit.packages.${pkgs.system}.default
  ];
}
