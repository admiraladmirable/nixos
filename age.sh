# for age..
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
# or to convert an ssh ed25519 key to an age key
# mkdir -p ~/.config/sops/age
# nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
# for GPG >= version 2.1.17
# gpg --full-generate-key
