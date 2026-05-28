{
  testers,
  nixosModule,
  ...
}:
testers.nixosTest {
  name = "nixos-module-check";

  nodes.machine =
    { ... }:
    {
      imports = [ nixosModule ];

      programs.cheat-sh = {
        enable = true;
        viewer = "cat";
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("command -v cheat-sh")
  '';
}
