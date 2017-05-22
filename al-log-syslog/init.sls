{% from "al-log-syslog/defaults.sls" import alertlogic_pkg_url with context %}


al-log-syslog:
  pkg:
    - installed
    - sources:
      - al-log-syslog: {{ alertlogic_pkg_url }}
  {% if (grains['os'] != 'Windows') %}
  service:
    - running
    - required:
      - pkg.installed
    - enable: True
    - restart: True
    # - watch:
    #   - file: /var/alertlogic/etc/host_key.pem
  {% endif %}
