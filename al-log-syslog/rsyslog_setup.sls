{% from "al-log-syslog/defaults.sls" import alertlogic_initscript with context %}

include:
  - al-log-syslog
# {# {% if salt['cmd.run'] %} #}
rsyslog:
  service.running:
    - watch:
      - file: /etc/rsyslog.d/alertlogic.conf
    - onlyif:
      - service rsyslog status | grep running

/etc/rsyslog.d/alertlogic.conf:
  file.managed:
    - source: salt://al-log-syslog/files/rsyslog/alertlogic.conf
    - onlyif:
      - service rsyslog status | grep running
