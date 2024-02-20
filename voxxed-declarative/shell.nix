let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    git
    python311
    nodejs
    cowsay
    lolcat
  ];

  GREETING = "Thank you, Voxxed Days Ioannina!!!";

  shellHook = ''
    echo $GREETING | cowsay | lolcat
  '';
}