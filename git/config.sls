{%- set email = salt['pillar.get']('git:email', 'hvnsweeting@gmail.com' %}
{%- set user = salt['pillar.get']('git:user', 'hvnsweeting') %}

git_config_user_name:
  cmd:
    - run
    - name: git config --global user.name {{ user }}
    - unless: test $(git config --get user.email) = {{ email }}

git_config_user_email:
  cmd:
    - wait
    - name: git config --global user.email "{{ email }}"
    - watch:
      - cmd: git_config_user_name

git_config_push_default:
  cmd:
    - wait
    - name: git config --global push.default simple
    - watch:
      - cmd: git_config_user_name

