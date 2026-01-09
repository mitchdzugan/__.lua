{
  description = "fennel util library";
  inputs = {
    mitch-utils.url = "github:mitchdzugan/mitch-utils.nix";
  };
  outputs = ({ mitch-utils, ... }:
    let
      mkLuaDeps = luaPkgs: with luaPkgs; [
        busted
        fennel
      ];
    in (mitch-utils.mkZnFnl "__" "0.0.1-0" mkLuaDeps ./.)
  );
}
