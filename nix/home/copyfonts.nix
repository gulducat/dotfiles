# some office suites (onlyoffice/euro-office) can't follow symlinks for fonts,
# so we need to copy the darn things.
{
  config,
  pkgs,
  lib,
  ...
}:

let
  hmFonts = "${config.home.profileDirectory}/share/fonts";
  localFonts = "${config.xdg.dataHome}/fonts/copied";
in
{

  # Workaround for euro-office font symlink limitation
  home.activation = {
    copyFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -eu

      if [ ! -d "${hmFonts}" ]; then
        echo "font dir not found: ${hmFonts}"
      exit 1
      fi

      # Clean out old mirrored copies
      rm -rf "${localFonts}"
      mkdir -p "${localFonts}"

      # Use rsync with the '-L' flag to follow/dereference symlinks and copy actual files
      ${pkgs.rsync}/bin/rsync -aL \
        --include='*/' --include='*.ttf' --include='*.otf' --exclude='*' \
        "${hmFonts}/" "${localFonts}/"

      # Correct the permissions so the FHS container can safely read them
      chmod -R 744 "${localFonts}"
      ${pkgs.findutils}/bin/find "${localFonts}" \
        -type f \( -name '*.ttf' -o -name '*.otf' \) \
        -exec chmod 0644 {} \;

      # Rebuild the font cache
      ${pkgs.fontconfig}/bin/fc-cache -f "${localFonts}" >/dev/null 2>&1 || true
    '';
  };
}
