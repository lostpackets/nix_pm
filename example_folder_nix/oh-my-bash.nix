{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "oh-my-bash";
  src = pkgs.fetchFromGitHub {
    owner = "ohmybash";
    repo = "oh-my-bash";
    rev = "60332ed8fb954f6e6c0af243933e67d570ffc2cc";
    sha256 = "17mg4frbmqlqxkhndh9x9yw9rdb4x7bsjwi4gkhzv0jwp742vdm6";
  };
  buildInputs = [ pkgs.bash ];
  installPhase = ''
    mkdir -p $out/etc/bash.bashrc.d
    cp -r $src $out/etc/bash.bashrc.d/oh-my-bash
  '';
}
