{ ... }:
{
  targets.genericLinux = {
    # https://nix-community.github.io/home-manager/options/home-manager/targets.html#opt-targets.genericLinux.enable
    enable = true;
    # https://nix-community.github.io/home-manager/usage/gpu-non-nixos.html
    gpu.enable = true; # not necessary, but nice to be explicit.
  };

}
