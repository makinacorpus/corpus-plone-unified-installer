{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{#-Cron from generic:
#    pack & backup & restart each day,
#    fullbackup per week (sunday)
#}
{%- set locations = salt['mc_locations.settings']() %}
{%- set cron_hour   = cfg.data.get('cron_hour', 1) %}
{%- set cron_minute = cfg.data.get('cron_minute', 0) %}
{{cfg.name}}-crons:
  file.managed:
    - name: /etc/cron.d/zope-{{cfg.name.replace('.', '_')}}
    - user: root
    - group: root
    - mode: 750
    - contents: |
                {% for i in data.supervisor_programs %}
                {%- if cfg.data['buildout']['settings']['autostart'].get(i, 'false') == 'true' %}
                # daily restart
                {{cron_minute+30}} {{cron_hour}} * * * {{cfg.user}} {{ data.zroot}}/bin/supervisorctl restart {{i}}
                {%- endif %}
                {%- endfor %}
                # daily incremental save
                {{ cron_minute + 15 }} {{cron_hour}} * * * {{cfg.user}} {{data.zroot}}/bin/backup
                #  weekly full save
                {{ cron_minute + 45 }} * * * 6 {{cfg.user}} {{data.zroot}}/bin/snapshotbackup
                # daily pack
                {{ cron_minute + 0 }} {{cron_hour}} * * * {{cfg.user}} {{data.zroot}}/bin/{{data.buildout.settings.zeoserver['zeopack-script-name']}}

{{cfg.name}}-logrotate:
  file.managed:
    - name: /etc/logrotate.d/{{cfg.name}}
    - source: salt://makina-projects/{{cfg.name}}/files/logrotate.conf.template
    - mode: 600
    - user: root
    - template: jinja
    - group: root
    - defaults:
        project_name: {{cfg.name}}
