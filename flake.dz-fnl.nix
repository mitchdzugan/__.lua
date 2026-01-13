{
  name = "__";
  version = "0.0.1-0";
  mkLuaDeps = env: [
    env.luaPackages.inspect
    env.luaPackages.middleclass
  ];
}
