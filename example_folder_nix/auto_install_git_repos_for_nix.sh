#!/home/$USER/.nix-profile/bin
#!/bin/bash
cd /nix
# This checks & auto installs nix-prefetch-git if it has not already
if [[ ! -x "$(command -v nix-prefetch-git)" ]]; then
    echo "nix-prefetch-git is not executable, installing it"
    nix-env -i nix-prefetch-git
else
    echo "nix-prefetch-git is already installed"
fi


# Prompt the user for the name
read -p "Enter the name of the package: " name

# Prompt the user for the owner
read -p "Enter the owner of the repository: " owner

# Show the nix-prefetch-git command
echo "Running the command: nix-prefetch-git https://github.com/$owner/$name.git HEAD"

# Get the git hash and sha256 hash
nix-prefetch-git https://github.com/$owner/$name.git HEAD

# This reads the keypress instantaneously
read -p "Do you want to continue to dl this github repo? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

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

# This will export the path from your nix profile so that you can call your nix binaries anywhere in PATH
export PATH="/home/$USER/.nix-profile/bin/:$PATH"

echo "Now you can run this github repo with the command: nix-env -i -f $name.nix"
# It will automatically state the path where it dl'ed, for example: shrinking RPATHs of ELF executables and libraries in /nix/store/hell092fprm2ju3o8qqkhahs4ch-oh-my-bash
# Run the path /nix/store/hell092fprm2ju3o8qqkhahs4ch-oh-my-bash which should be located at /nix/store/hell092fprm2ju3o8qqkhahs4ch-oh-my-bash/ + "etc/bash.bashrc.d/oh-my-bash/tools/install.sh". My script was written in a way that it copies its dir and sources it at \$src \$out/etc/bash.bashrc.d/$name
