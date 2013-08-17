include:
  - git.base

{%- set email = salt['pillar.get']('git:config:email', 'hvnsweeting@gmail.com') %}
{%- set user = salt['pillar.get']('git:config:user', 'hvnsweeting') %}
{%- set uid = salt['pillar.get']('git:user', 'root') %}
{%- set push = salt['pillar.get']('git:config:push', 'simple') %}
git_config_user_name:
  cmd:
    - run
    - name: git config --global user.name {{ user }}
    - unless: test $(git config --global --get user.email) = {{ email }}
    - user: {{ uid }}
    - require:
      - pkg: git

git_config_user_email:
  cmd:
    - wait
    - user: {{ uid }}
    - name: git config --global user.email "{{ email }}"
    - watch:
      - cmd: git_config_user_name

git_config_push_default:
  cmd:
    - run
    - user: {{ uid }}
    - name: git config --global push.default {{ push }}
    - unless: test $(git config --global --get push.default) = 'simple'
    - require:
      - cmd: git_config_user_name
