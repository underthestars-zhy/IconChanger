content=$(sudo cat /private/etc/sudoers)

sudo chmod 777 '%path'
sudo chmod 777 '%fileicon'
sudo chown root '%path'
sudo chown root '%fileicon'

if [[ $content == *"ALL ALL=(ALL) NOPASSWD: %path"* ]]; then
  exit 8
fi

sudo su root -c 'chmod +w /private/etc/sudoers && echo "ALL ALL=(ALL) NOPASSWD: %path\n" >> /private/etc/sudoers'
