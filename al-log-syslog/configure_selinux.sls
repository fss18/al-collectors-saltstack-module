configure_selinux:
  cmd.run:
    - name: semanage port -a -t syslogd_port_t -p tcp 1514
    - onlyif:
      - grep SELINUX=enforcing /etc/selinux/config
