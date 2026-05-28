{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.cheat-sh;
in
{
  options.programs.cheat-sh = {
    enable = lib.mkEnableOption "cheat-sh";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ../cheat-sh.nix { };
      description = "cheat-sh package to use.";
    };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      description = "Resulting customized cheat-sh package.";
    };

    viewer = lib.mkOption {
      type = lib.types.lines;
      default = "${lib.getExe pkgs.bat}";
      description = "Which viewer command to use with bat";
      defaultText = lib.literalExpression "${lib.getExe pkgs.bat}";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.finalPackage
    ];

    programs.cheat-sh.finalPackage = cfg.package.overrideAttrs (_: {
      viewer = cfg.viewer;
    });
  };
}
