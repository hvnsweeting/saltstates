old_ruby:
  pkg.purged:
    - names:
      - ruby1.8 
      - rubygems
      - rake
      - ruby-dev
      - libreadline5 
      - libruby1.8 
      - ruby1.8-dev

ruby:
  pkg.installed:
    - names:
      - ruby1.9.3
      - ruby1.9.1-dev 
    - require:
      - pkg: old_ruby
