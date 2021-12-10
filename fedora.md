# Fedora 35

```sh
  # update the packages
  dnf update -y

  # install essentials git htop tmux vim
  dnf install -y git htop tmux vim

  # get a copy of the init script scp from server
  mkdir config

  # copy file to enable prometheus logging
  cp config/node_exporter.service /etc/systemd/system/
  systemctl daemon-reload
  systemctl enable node_exporter.service
  systemctl start node_exporter.service

  # update dotfiles
  git clone https://github.com/rahulkadukar/notes.git temp-dotfiles-folder-782ffb && \
  mkdir -p ~/.vim/colors && \
  cp temp-dotfiles-folder-782ffb/config/.vim/colors/lucius.vim ~/.vim/colors/lucius.vim && \
  cp temp-dotfiles-folder-782ffb/config/.vimrc ~/.vimrc && \
  cp temp-dotfiles-folder-782ffb/config/.tmux.conf ~/.tmux.conf && \
  cp temp-dotfiles-folder-782ffb/config/.gitconfig ~/.gitconfig && \
  rm -rf temp-dotfiles-folder-782ffb/

  # install nodejs
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
  source ~/.bashrc
  nvm install 16.13.1
```


## v1.0 (2021-12-10)

* Installation with user tars and root
* Updated Kernel to **5.15.6**
* Installed
  - git
  - htop
  - tmux
  - vim
* Setup prometheus monitoring [**FIXME**]
* Updated dotfiles for
  - git
  - tmux
  - vim
* Installed node js version 16.13.1

### TO FIX
* Prometheus setup was done manually
