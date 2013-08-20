emacs:
  pkgrepo:
    - managed
    - ppa: cassou/emacs
  pkg: 
    - installed
    - pkgs:
      - emacs24 
      - emacs24-el
      - emacs24-common-non-dfsg
    - require:
      - pkgrepo: emacs
