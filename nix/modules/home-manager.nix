{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.cheat-sh;
  cheat-sh = pkgs.callPackage ../cheat-sh.nix { };
in
{
  options.programs.cheat-sh = {
    enable = lib.mkEnableOption "";

    package = lib.mkOption {
      type = lib.types.package;
      default = cheat-sh;
      description = "cheat-sh package to use.";
    };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      visible = false;
      readOnly = true;
      description = "Resulting customized cheat-sh package.";
    };

    viewer = lib.mkOption {
      type = lib.types.string;
      default = "${lib.getExe pkgs.bat}";
      description = "Which viewer command to use with bat";
      defaultText = lib.literalExpression "${lib.getExe pkgs.bat}";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      config.programs.cheat-sh.finalPackage
    ];

    programs.cheat-sh.finalPackage = config.programs.cheat-sh.package.override (old: {
      viewer = config.programs.cheat-sh.viewer;
    });
  };
}
