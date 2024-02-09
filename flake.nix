{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";
    devenv.url = "github:cachix/devenv/v0.6.3";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    devShells.${system}.default = devenv.lib.mkShell {
      inherit pkgs inputs;
      modules = [
        ({ pkgs, config, ... }:
          {
            devcontainer = {
              enable = true;
              settings = {
                updateContentCommand = null;
              };
            };
            packages = with pkgs; [
              mkdocs
            ];    
            processes.mkdocs-serve.exec = "mkdocs serve";
          }
        )
      ];
    };
  };
}

