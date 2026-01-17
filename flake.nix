{
  description = "fennel util library";
  inputs = {
    # mitch-utils.url = "path:/VOID/proj/mitch-utils.nix";
    # mitch-utils.url = "path:/home/dz/Projects/mitch-utils.nix";
    mitch-utils.url = "github:mitchdzugan/mitch-utils.nix";
  };
  outputs = ({ mitch-utils, ... }: (mitch-utils.mkZnFnl ./.));
}
