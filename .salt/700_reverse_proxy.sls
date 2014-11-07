{% set cfg = opts['ms_project'] %}
{% import "makina-states/services/http/nginx/init.sls" as nginx with context %}
include:
  - makina-states.services.http.nginx
{% set data = cfg.data %}
# incondentionnaly reboot nginx upon deployments
echo reboot:
  cmd.run:
    - watch_in:
      - mc_proxy: nginx-pre-restart-hook
      - mc_proxy: nginx-pre-hardrestart-hook

{{nginx.virtualhost(data.domain,
                    data.www_dir,
                    server_aliases=data.server_aliases,
                    vh_top_source=data.nginx_top,
                    vh_content_source=data.nginx_vhost,
                    cfg=cfg)}}
