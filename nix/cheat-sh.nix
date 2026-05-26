{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.writeShellApplication {
  name = "cheat-sh";

  derivationArgs = {
    __structuredAttrs = true;
    strictDeps = true;
  };

  runtimeInputs = with pkgs; [
    fzf
    curl
    less
  ];

  text = builtins.readFile ../src/script.sh;
}
