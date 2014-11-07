{% set cfg = opts.ms_project %}
{{cfg.name}}-develop-up:
  cmd.run:
    - name: {{cfg.data.zroot}}/bin/develop up -f
    - cwd: {{cfg.data.zroot}}
    - user: {{cfg.user}}
