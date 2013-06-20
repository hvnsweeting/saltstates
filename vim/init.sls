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

cp -r ftdetect ftplugin syntax /usr/share/vim/vimfiles:
  cmd:
    - run
    - cwd: /tmp/salt-vim
    - unless: test -e /usr/share/vim/vimfiles/syntax/sls.vim
    - require:
      - git: git_salt_vim
      - pkg: vim

git_jinja2_vim:
  git:
    - latest
    - name: git://github.com/Glench/Vim-Jinja2-Syntax.git
    - rev: master
    - target: {{ opts['cachedir'] }}/vim_jinja2
    - require:
      - ssh_known_hosts: github.com
      - pkg: git
  cmd:
    - run
    - name: cp -r ftdetect indent syntax /usr/share/vim/vimfiles
    - unless: test -e /usr/share/vim/vimfiles/syntax/jinja.vim
    - cwd: {{ opts['cachedir'] }}/vim_jinja2
    - require:
      - git: git_jinja2_vim
      - pkg: vim

/etc/vim/vimrc.local:
  file:
    - managed
    - template: jinja
    - source: salt://vim/vimrc.jinja2
    - requrie:
      - pkg: vim

