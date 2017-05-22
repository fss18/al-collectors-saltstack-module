{% from "al-log-syslog/defaults.sls" import alertlogic_syslog_ng_source with context %}

include:
  - al-log-syslog

/etc/syslog-ng/syslog-ng.conf:
  file.append:
    - text:
      - "include '/etc/syslog-ng/conf.d/alertlogic.conf';"
    - onlyif:
      - ls /etc/init.d/syslog-ng
    - unless:
      - grep /etc/syslog-ng/conf.d/alertlogic.conf /etc/syslog-ng/syslog-ng.conf

/etc/syslog-ng/conf.d/alertlogic.conf:
  file.managed:
    - source: salt://al-log-syslog/files/syslog-ng/alertlogic.conf
    - template: jinja
    - defaults:
       syslog_ng_source: {{ alertlogic_syslog_ng_source }}

    - onlyif:
      - ls /etc/init.d/syslog-ng

syslog-ng:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/syslog-ng/conf.d/alertlogic.conf
      - file: /etc/syslog-ng/syslog-ng.conf
    - onlyif:
      - ls /etc/init.d/syslog-ng
