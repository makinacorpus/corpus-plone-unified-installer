{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{%- set sdata = salt['mc_utils.json_dump'](cfg.data) %}
{#- Run the project buildout but skip the maintainance parts #}
{#- Wrap the salt configured setting in a file inputable to buildout #}
{{cfg.name}}-buildout-project:
  file.managed:
    - template: jinja
    - name: {{data.zroot}}/buildout-salt.cfg
    - source: salt://makina-projects/{{cfg.name}}/files/settings.cfg
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - mode: 770
    - defaults:
        project_name: {{cfg.name}}
  buildout.installed:
    - name: {{data.zroot}}
    - config: buildout-salt.cfg
    - runas: {{cfg.user}}
    - newest: {{{'true': True}.get(cfg.data.buildout.settings.buildout.get('newest', 'false').lower(), False)  }}
    - python: /usr/bin/python2.6
    - use_vt: true
    - output_loglevel: info
    - watch:
      - file: {{cfg.name}}-buildout-project
