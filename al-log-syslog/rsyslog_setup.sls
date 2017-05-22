{% from "al-log-syslog/defaults.sls" import alertlogic_initscript with context %}

include:
  - al-log-syslog
# {# {% if salt['cmd.run'] %} #}
rsyslog:
  service.running:
    - watch:
      - file: /etc/rsyslog.d/alertlogic.conf
    - onlyif:
      - ls /etc/init.d/{{ alertlogic_initscript }}

/etc/rsyslog.d/alertlogic.conf:
  file.managed:
    - source: salt://al-log-syslog/files/rsyslog/alertlogic.conf
    - onlyif:
      - ls /etc/init.d/{{ alertlogic_initscript }}
