{
  description = "fennel util library";
  inputs = {
    mitch-utils.url = "github:mitchdzugan/mitch-utils.nix";
  };
  outputs = (inputs@{ mitch-utils, ... }:
    (mitch-utils.mkZnFnl inputs ./.)
  );
}
