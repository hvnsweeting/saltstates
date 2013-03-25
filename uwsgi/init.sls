include:
  - pip

uwsgitop:
  pip.installed:
    - require:
      - pkg: python-pip

depends:
  pkg.installed:
    - names:
      - build-essential
      - python-dev
      - libxml2-dev

uwsgi:
  pip.latest:
    - require:
      - pkg: python-pip
      - pkg: depends

