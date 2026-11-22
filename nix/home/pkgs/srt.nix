# https://github.com/anthropics/sandbox-runtime
{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage(finalAttrs: {
  pname = "srt";
  version = "0.0.78";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "sandbox-runtime";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ChqWdx8unuXjlg+F7yeBNYK79y7Mf+0aNr/Y5htPBoQ=";
  };

  npmDepsHash = "sha256-l9eGVqggdBbTQt9kWmJMgMZLUZOYfXY65ZjShslTn9k=";

  meta = with lib; {
    description = "convenience wrapper around bwrap";
    homepage = "https://github.com/anthropics/sandbox-runtime";
    license = licenses.asl20; # apache 2.0
    mainProgram = "srt";
  };
})
