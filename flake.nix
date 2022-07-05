{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    outputs = { self, nixpkgs, flake-utils, }:
        flake-utils.lib.eachDefaultSystem (system:
            let 
                pkgs = import nixpkgs { inherit system; };
                luaEnv = pkgs.lua.withPackages(ps: [ ps.lpeg ]);
            in {
                devShells.default = pkgs.mkShell {
                    buildInputs = with pkgs; [ 
                        ncurses
                        libtermkey
                        luaEnv
                        tre
                        acl
                        libselinux
                    ];
                    shellHook = ''
                          export LUA_CPATH=${luaEnv}/lib/lua/${pkgs.lua.luaversion}/?.so
                          export LUA_PATH=${luaEnv}/share/lua/${pkgs.lua.luaversion}/?.lua
                          export VIS_PATH=\$HOME/.config:.
                    '';
                };
            }
        );
}
