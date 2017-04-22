{% set cfg = opts.ms_project %}
{% if cfg.data.get('symlinks', []) %}
{% for recordslist in cfg.data.symlinks %}
{% for i, t in recordslist.items() %}
{{cfg.name}}-symzeo-{{i}}-{{t}}:
  file.symlink:
    - name: {{i}}
    - target: {{t}}
    - makedirs: true
{% endfor %}
{% endfor %}
{% endif %}
