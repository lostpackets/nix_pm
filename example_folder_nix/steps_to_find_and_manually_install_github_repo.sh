# This isn't meant to be ran as a shell script or anything, the file extension just helps me see the syntax highlighting

# Going into the /nix dir first
cd /nix

nix-build oh-my-bash.nix



# Incase there are any errors from nix
unset NIX_REMOTE


# Goes into /nix/store
cd /nix/store
# This isn't meant to be ran as a shell script or anything, the file extension just helps me see the syntax highlighting

# Incase there are any errors from nix
unset NIX_REMOTE


# This makes the files for the pkg you build... it will be an id[a-z0-9]...-$yourpkgname.drv?
nix-env -i -f oh-my-bash.nix
# This part builds it

# After going to the /nix/store dir, you'd need the file that was just made by nix-env -i -f $yourpkgname. The command: ls -t sorts by time of the file creation, etc.
ls -t| grep -E '^[a-z0-9]{32}-oh-my-bash$'|head -n 1

# Going back to /nix dir (Sometimes building inside the /nix/store dir will not work)
cd /nix

# Needing to get into nix-shell to build it
# Unset incase there are any issues from nix, again
unset NIX_REMOTE

nix-shell -p
# Inside nix-shell within the /nix dir, it will build it
# You will use this build it outputs:
nix-build oh-my-bash.nix

# This part is very specific and needs for you to go inside and run the scripts provided from inside the github's repo (you have to manually install it if it was formerly automatic when ran)
# The ./install.sh which is usually installed inside of a git cloned folder, is now in /nix/store/^[a-z0-9]$yourpkgname
# And from your flake .nix file, its source will be based on your .nix file build. Mines is $src at /etc/bash.bashrc.d/oh-my-bash, for example.
#                                                                                                                       \----- Can be any folder name :)
/nix/store/6f2sr8cjgcnafpaz2zbhh98q9qis3plc-oh-my-bash/etc/bash.bashrc.d/oh-my-bash/tools/install.sh
