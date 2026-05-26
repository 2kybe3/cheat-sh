{
  pkgs,
  home-manager,
  ...
}:
pkgs.testers.nixosTest {
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
            ../modules/home-manager.nix
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
  '';
}
