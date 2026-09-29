# onlyoffice can't follow symlinks for fonts,
# so we need to copy the darn things for it.
{
  config,
  pkgs,
  lib,
  ...
}:

let
  # The directory where Home Manager links your user fonts
  hmFonts = "${config.home.profileDirectory}/share/fonts";
  # The directory where OnlyOffice looks for custom user fonts
  ooFonts = "${config.xdg.dataHome}/fonts/onlyoffice";
in
{

  # Ensure your required system fonts are actually declared in home-manager:
  home.packages = with pkgs; [
    corefonts # Microsoft core fonts (Arial, Times New Roman)
    eb-garamond
    garamond-libre
    #noto-fonts # Google Noto Sans
    # Add any other font packages you like here
  ];

  # Workaround for OnlyOffice font symlink limitation
  home.activation = {
    onlyofficeUserFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -eu
      # Clean out old mirrored copies
      rm -rf "${ooFonts}"
      mkdir -p "${ooFonts}"

      # Use rsync with the '-L' flag to follow/dereference symlinks and copy actual files
      if [ -d "${hmFonts}" ]; then
        ${pkgs.rsync}/bin/rsync -aL \
          --include='*/' --include='*.ttf' --include='*.otf' --exclude='*' \
          "${hmFonts}/" "${ooFonts}/"
      fi

      # Correct the permissions so the FHS container can safely read them
      chmod -R 744 "${ooFonts}"
      ${pkgs.findutils}/bin/find "${ooFonts}" -type f \( -name '*.ttf' -o -name '*.otf' \) -exec chmod 0644 {} \;

      # Rebuild the font cache specifically for OnlyOffice
      ${pkgs.fontconfig}/bin/fc-cache -f "${ooFonts}" >/dev/null 2>&1 || true
    '';
  };
}
