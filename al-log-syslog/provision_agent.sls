{% from "al-log-syslog/defaults.sls" import alertlogic_provision_options, alertlogic_for_imaging with context %}
{% from "al-log-syslog/config.sls" import alertlogic_for_imaging with context %}

include:
  - al-log-syslog
  - al-log-syslog.configure_agent


{% if alertlogic_for_imaging == False %}
provision_agent:
  cmd.run:
    - user: root
    - name: /etc/init.d/al-log-syslog provision {{ alertlogic_provision_options }}
    - unless:
      - ls /var/alertlogic/etc/host_key.pem

al-agent-provision:
  module.run:
    - order: last
    - name: service.restart
    - m_name: al-log-syslog
{% endif %}
