{
  pkgs,
  ...
}:
pkgs.testers.nixosTest {
  name = "nixos-module-check";

  nodes.machine =
    { ... }:
    {
      imports = [ ../modules/nixos.nix ];

      programs.cheat-sh = {
        enable = true;
        viewer = "cat";
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
  '';
}
