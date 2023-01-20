#!/home/$USER/.nix-profile/bin
#!/bin/bash

# Prompt the user for the name
read -p "Enter the name of the package: " name

# Prompt the user for the owner
read -p "Enter the owner of the repository: " owner

# Show the nix-prefetch-git command
echo "Running the command: nix-prefetch-git https://github.com/$owner/$name.git HEAD"

# Get the git hash and sha256 hash
nix-prefetch-git https://github.com/$owner/$name.git HEAD

output=$(nix-prefetch-git https://github.com/$owner/$name.git HEAD &)
wait
echo $output
rev=$(echo $output |grep -o '"rev":.*' | awk -F '"' '{print $4}')
sha256=$(echo $output |grep -o '"sha256":.*' | awk -F '"' '{print $4}')
# Create the .nix file
cat > $name.nix << EOL
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "$name";
  src = pkgs.fetchFromGitHub {
    owner = "$owner";
    repo = "$name";
    rev = "$rev";
    sha256 = "$sha256";
  };
  buildInputs = [ pkgs.bash ];
  installPhase = ''
    mkdir -p \$out/etc/bash.bashrc.d
    cp -r \$src \$out/etc/bash.bashrc.d/$name
  '';
}
EOL

echo "Now you can run this github repo with the command: nix-env -i -f $name.nix"
