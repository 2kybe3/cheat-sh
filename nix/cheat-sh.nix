{
  fzf,
  curl,
  less,
  writeShellApplication,
  ...
}:
writeShellApplication {
  name = "cheat-sh";

  derivationArgs = {
    __structuredAttrs = true;
    strictDeps = true;
  };

  runtimeInputs = [
    fzf
    curl
    less
  ];

  text = builtins.readFile ../src/script.sh;
}
