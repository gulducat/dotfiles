{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
      inputs.crit.packages.${pkgs.system}.default
  ];
}
