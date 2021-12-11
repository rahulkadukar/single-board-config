# Fedora 35

Run the following file to get the same results

```sh
  #! /bin/bash
  USER=tars

  # update the packages
  dnf update -y

  # install essentials git htop tmux vim
  dnf install -y git htop tmux vim

  # update dotfiles
  git clone https://github.com/rahulkadukar/notes.git temp-dotfiles-folder-782ffb
  mkdir -p /home/$USER/.vim/colors
  cp temp-dotfiles-folder-782ffb/config/.vim/colors/lucius.vim /home/$USER/.vim/colors/lucius.vim 
  cp temp-dotfiles-folder-782ffb/config/.vimrc /home/$USER/.vimrc
  cp temp-dotfiles-folder-782ffb/config/.tmux.conf /home/$USER/.tmux.conf
  cp temp-dotfiles-folder-782ffb/config/.gitconfig /home/$USER/.gitconfig

  # update permissions
  chown -R $USER:$USER /home/$USER/.vim/colors
  chown -R $USER:$USER /home/$USER/.vimrc
  chown -R $USER:$USER /home/$USER/.tmux.conf
  chown -R $USER:$USER /home/$USER/.gitconfig

  # copy file to enable prometheus logging
  cp temp-dotfiles-folder-782ffb/config/node_exporter.service /etc/systemd/system/ && \
  rm -rf temp-dotfiles-folder-782ffb/

  # setup user and configuration for prometheus
  useradd -M -r -s /sbin/nologin node_exporter
  getent passwd node_exporter

  wget -P /opt/ https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
  cd /opt
  tar xf node_exporter-1.1.2.linux-amd64.tar.gz
  ln -s node_exporter-1.1.2.linux-amd64 node_exporter

  chown -R node_exporter:node_exporter /opt/node_exporter-1.1.2.linux-amd64 node_exporter*

  mkdir -p /var/lib/node_exporter/textfile_collector
  chown node_exporter:node_exporter /var/lib/node_exporter/textfile_collector
  touch /etc/sysconfig/node_exporter
  chown node_exporter:node_exporter /etc/sysconfig/node_exporter

  firewall-cmd --add-port=9101/tcp --permanent
  firewall-cmd --reload

  systemctl daemon-reload
  systemctl enable node_exporter.service
  systemctl start node_exporter.service

  # install nodejs
  runuser -l $USER -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash && \
  source ~/.bashrc && nvm install 16.13.1"
```

## v1.0 (2021-12-10)

* Installation with user tars and root
* Updated Kernel to **5.15.6**
* Installed
  - git
  - htop
  - tmux
  - vim
* Setup prometheus monitoring 
* Updated dotfiles for
  - git
  - tmux
  - vim
* Installed node js version 16.13.1
