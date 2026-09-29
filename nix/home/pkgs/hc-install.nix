{ lib, buildGoModule, fetchFromGitHub }:

# hc-install (https://github.com/hashicorp/hc-install) has no nixpkgs package
# as of writing, so this is a small custom derivation. `buildGoModule` is the
# standard nixpkgs helper for packaging Go projects: it fetches the source,
# then fetches all Go module dependencies into a separate fixed-output
# derivation (hashed by `vendorHash`), then builds the `./cmd/...` binaries.
buildGoModule rec {
  pname = "hc-install";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hc-install";
    rev = "v${version}";
    hash = "sha256-+wu8ehJvDZQwTexntc8x/dWxs1l+7RtkwynbASeOO0M=";
  };

  # Hash of the vendored Go module dependencies (go.sum contents), not the
  # source itself. This intentionally starts wrong (lib.fakeHash); building
  # once will fail with an error telling you the real hash to paste in here.
  # This is the standard nixpkgs workflow for packaging any Go project.
  vendorHash = "sha256-yMYFJ4BwqSOvT0StEpBi19CRs4yZdc7Htn3ZN0zm6Lc=";

  subPackages = [ "cmd/hc-install" ];

  meta = with lib; {
    description = "Installer for HashiCorp tools";
    homepage = "https://github.com/hashicorp/hc-install";
    license = licenses.mpl20;
    mainProgram = "hc-install";
  };
}
