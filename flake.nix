{
  description = "fennel util library";
  inputs = {
    # mitch-utils.url = "path:/VOID/proj/mitch-utils.nix";
    # mitch-utils.url = "path:/home/dz/Projects/mitch-utils.nix";
    mitch-utils.url = "github:mitchdzugan/mitch-utils.nix";
  };
  outputs = ({ mitch-utils, ... }:
    let
      mkLuaDeps = luaPkgs: with luaPkgs; [
        inspect
        middleclass
      ];
    in (mitch-utils.mkZnFnl "__" "0.0.1-0" mkLuaDeps ./.)
  );
}
