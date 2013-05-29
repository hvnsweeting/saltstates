include:
  - git

vim:
  pkg:
    - installed

git://github.com/saltstack/salt-vim.git:
  git:
    - latest
    - rev: master
    - target: /tmp/salt-vim
    - require:
      - pkg: git
      - pkg: vim

/etc/vim/vimrc.local:
  file:
    - managed
    - template: jinja
    - source: salt://vim/vimrc.jinja2
    - requrie:
      - pkg: vim

