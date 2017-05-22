{% from "al-log-syslog/defaults.sls" import alertlogic_configure_options, alertlogic_registration_key %}
{% from "al-log-syslog/config.sls" import alertlogic_registration_key with context %}

include:
  - al-log-syslog

{% if alertlogic_registration_key != False %}
configure_agent:
  cmd.run:
    - name: ./al-log-syslog configure {{ alertlogic_configure_options }}
    - user: root
    - cwd: /etc/init.d
    - unless:
      - ls /var/alertlogic/etc/host_key.pem
{% endif %}
