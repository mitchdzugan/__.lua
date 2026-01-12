{ pkgs, luaPackages, ... }:
{
  name = "__.lua";
  version = "0.0.1-0";
  luaDeps = [
    luaPackages.inspect
    luaPackages.middleclass
  ];
}
