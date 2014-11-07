

ald-sav-project-dir:
  cmd.run:
    - name: |
            if [ ! -d "/srv/projects/ald/archives/2014-11-06_17_18-32_6a52a084-3922-4374-975b-560a2e1c4991/project" ];then
              mkdir -p "/srv/projects/ald/archives/2014-11-06_17_18-32_6a52a084-3922-4374-975b-560a2e1c4991/project";
            fi;
            rsync -Aa --delete "/srv/projects/ald/project/" "/srv/projects/ald/archives/2014-11-06_17_18-32_6a52a084-3922-4374-975b-560a2e1c4991/project/"
    - user: root
