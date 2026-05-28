{
  testers,
  home-manager,
  homeManagerModule,
  ...
}:
testers.nixosTest {
  name = "nixos-module-check";
  nodes.machine =
    { ... }:
    {
      imports = [ home-manager.nixosModules.home-manager ];

      users.users.test.isNormalUser = true;

      home-manager.users.test =
        { ... }:
        {
          imports = [
            homeManagerModule
          ];

          programs.cheat-sh = {
            enable = true;
            viewer = "cat";
          };

          home.stateVersion = "26.05";
        };
    };
  testScript = ''
    machine.wait_for_unit("multi-user.target")

    machine.succeed("su - test -c 'true'")

    machine.succeed("command -v cheat-sh || true")
  '';
}
