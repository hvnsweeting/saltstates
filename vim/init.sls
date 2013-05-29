include:
  - git

vim:
  pkg:
    - installed

git_salt_vim:
  git:
    - latest
    - name: git://github.com/saltstack/salt-vim.git
    - rev: master
    - target: /tmp/salt-vim
    - require:
      - ssh_known_hosts: github.com
      - pkg: git
      - pkg: vim

cp -r ftdetect ftplugin syntax /usr/share/vim/vimfiles:
  cmd:
    - run
    - cwd: /tmp/salt-vim
    - unless: test -e /usr/share/vim/vimfiles/syntax/sls.vim
    - require:
      - git: git_salt_vim

/etc/vim/vimrc.local:
  file:
    - managed
    - template: jinja
    - source: salt://vim/vimrc.jinja2
    - requrie:
      - pkg: vim

