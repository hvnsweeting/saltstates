include:
  - git.base

{%- set email = salt['pillar.get']('git:config:email', 'hvnsweeting@gmail.com') %}
{%- set user = salt['pillar.get']('git:config:user', 'hvnsweeting') %}
{%- set system_user = salt['pillar.get']('git:user', 'root') %}
{%- set push = salt['pillar.get']('git:config:push', False) %}

git_config_user_name:
  cmd:
    - run
    - name: git config --global user.name {{ user }}
    - unless: test "$(git config --global --get user.name)" = {{ user }}
    - user: {{ system_user }}
    - require:
      - pkg: git

git_config_user_email:
  cmd:
    - wait
    - user: {{ system_user }}
    - name: git config --global user.email "{{ email }}"
    - watch:
      - cmd: git_config_user_name

{%- if push %}
git_config_push_default:
  cmd:
    - run
    - user: {{ system_user }}
    - name: git config --global push.default {{ push }}
    - unless: test "$(git config --global --get push.default)" = {{ push }}
    - require:
      - cmd: git_config_user_name
{%- endif %}
