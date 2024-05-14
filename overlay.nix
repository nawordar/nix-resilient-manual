final: prev: {
  luajitEnv = final.luajit.withPackages (ps:
    with ps; [
      # Default packages, copied from nixpkgs
      bit32
      cassowary
      cjson
      cldr
      compat53
      cosmo
      fluent
      linenoise
      loadkit
      lpeg
      lua-zlib
      lua_cliargs
      luaepnf
      luaexpat
      luafilesystem
      luarepl
      luasec
      luasocket
      luautf8
      penlight
      vstruct

      # Other Lua packages
      resilient-sile
    ]);

  sile =
    (prev.sile.overrideAttrs (oldAttr: {
      configureFlags = ["--with-luajit"] ++ oldAttr.configureFlags;
      buildInputs = [final.luajitEnv] ++ (prev.lib.lists.drop 1 oldAttr.buildInputs);
    }))
    .override {
      lua = final.luajitEnv;
    };
}
