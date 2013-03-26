include:
  - pip

uwsgitop:
  pip.installed:
    - require:
      - pkg: python-pip

pip-depends:
  pkg.installed:
    - names:
      - build-essential
      - python-dev
      - libxml2-dev

uwsgi:
  pip.installed:
    - require:
      - pkg: python-pip
      - pkg: pip-depends
