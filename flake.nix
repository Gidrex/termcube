{
  description = "Termcube - Rust 3D куб с использованием wgpu и winit";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          name = "termcube-dev-shell";

          buildInputs = with pkgs; [
            rustup
            pkg-config
            xorg.libX11
            xorg.libxcb
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXi
            xorg.libXrender
            xorg.libXxf86vm
            xorg.xrandr
            mesa
            glibc
            cmake
          ];

          shellHook = ''
            export RUST_BACKTRACE=1
            if ! command -v rustc &> /dev/null; then
              echo "Rust not installed. Installing..."
              rustup-init -y
              source $HOME/.cargo/env
            fi
            rustup default stable
          '';
        };

        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "termcube";
          version = "0.1.0";
          src = ./.;
          cargoBuildFlags = ["--release"];

          buildInputs = with pkgs; [
            pkgconfig
            xorg.libX11
            xorg.libxcb
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXi
            xorg.libXrender
            xorg.libXxf86vm
            opengl
            mesa
            glibc
          ];

          cargoToml = ./Cargo.toml;
          cargoLock = ./Cargo.lock;

          meta = with pkgs.lib; {
            description = "Termcube - Rust 3D cube, using wgpu and winit";
            license = licenses.mit;
            maintainers = with maintainers; [ Gidrex ];
          };
        };
      }
    );
}
