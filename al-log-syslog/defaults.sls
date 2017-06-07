{% from "al-log-syslog/config.sls" import alertlogic_registration_key, alertlogic_egress_url, alertlogic_proxy_url, alertlogic_port, alertlogic_for_imaging with context %}

{% set alertlogic_linux_configure = [] %}
{% set alertlogic_linux_provision = [] %}
{% set alertlogic_windows_options = [] %}

# Setting variables for provisioning of the agent
{% if alertlogic_registration_key != False %}
  {% do alertlogic_linux_provision.append(' --key ' ~ alertlogic_registration_key) %}
  {% if (grains['os'] == 'Windows') %}
    {% if salt.cmd.run('type "C:\Program Files (x86)\Common Files\AlertLogic\host_key.pem"') == True %}
      {% do alertlogic_windows_options.append('PROV_NOW=0') %}
      {% do alertlogic_windows_options.append('INSTALL_ONLY=1') %}
    {% else %}
      {% do alertlogic_windows_options.append('PROV_KEY=' ~ alertlogic_registration_key) %}
    {% endif %}
  {% endif %}
{% endif %}

# Setting variables for configuring the agent
{% if alertlogic_proxy_url != False %}
  {% do alertlogic_linux_configure.append(' --proxy ' ~ alertlogic_proxy_url) %}
  {% do alertlogic_windows_options.append('USE_PROXY=' ~ alertlogic_proxy_url) %}
{% endif %}

{% if alertlogic_egress_url != False %}
  {% do alertlogic_linux_configure.append('--host ' ~ alertlogic_egress_url) %}
  {% do alertlogic_windows_options.append('SENSOR_HOST=' ~ alertlogic_egress_url) %}
{% endif %}

{% if alertlogic_for_imaging == True %}
  {% do alertlogic_windows_options.append('PROV_ONLY=host') %}
  {% do alertlogic_windows_options.append('INSTALL_ONLY=1') %}
{% endif %}


{% set alertlogic_provision_options = alertlogic_linux_provision|join(' ') %}
{% set alertlogic_configure_options = alertlogic_linux_configure|join(' ') %}
{% set alertlogic_windows_install_options = alertlogic_windows_options|join(' ') %}

# SENSOR_HOST, SENSOR_PORT, USE_PROXY, PROV_NOW, PROV_KEY, PROV_ONLY, INSTALL_ONLY

# Set up the download url based on system information
{% set alertlogic_base_url = 'https://scc.alertlogic.net' %}
{% if (grains['os_family'] == 'Debian') %}
  {% set alertlogic_pkg_name_prefix = 'al-log-syslog_LATEST_' %}

  {% set alertlogic_initscript = 'rsyslog' %}
  {% set alertlogic_pkg_name_arch = 'amd64' %}
  {% set alertlogic_pkg_name_ext = 'deb' %}
  {% if grains['osmajorrelease'] >= 7 %}
    {% set alertlogic_syslog_ng_source = 's_all' %}
  {% elif grains['osmajorrelease'] < 7 %}
    {% set alertlogic_syslog_ng_source = 's_sys' %}
  {% endif %}
{% elif (grains['os_family'] == 'RedHat') %}
  {% set alertlogic_pkg_name_prefix = 'al-log-syslog-LATEST-1.' %}
  {% set alertlogic_initscript = 'rsyslog' %}
  {% if grains['cpuarch'] == 'i686' %}
    {% set alertlogic_pkg_name_arch = 'i386' %}
  {% else %}
    {% set alertlogic_pkg_name_arch = grains['cpuarch'] %}
  {% endif %}
  {% set alertlogic_pkg_name_ext = 'rpm' %}
  {% if grains['osmajorrelease'] >= 6 %}
    {% set alertlogic_syslog_ng_source = 's_all' %}
  {% elif grains['osmajorrelease'] < 6 %}
    {% set alertlogic_syslog_ng_source = 's_sys' %}
  {% endif %}
{% else %}
  {% set alertlogic_pkg_name_prefix = '' %}
  {% set alertlogic_pkg_name_arch = '' %}
  {% set alertlogic_pkg_name_ext = '' %}
{% endif %}

{% set alertlogic_linux_pkg_url = alertlogic_base_url ~ '/software/' ~ alertlogic_pkg_name_prefix ~ alertlogic_pkg_name_arch ~ '.' ~ alertlogic_pkg_name_ext %}
{% set alertlogic_win_pkg_url = alertlogic_base_url ~ '/software/al_log_syslog-LATEST.msi' %}

{% if (grains['os'] == 'Windows') %}
  {% set alertlogic_pkg_url = alertlogic_win_pkg_url %}
{% else %}
  {% set alertlogic_pkg_url = alertlogic_linux_pkg_url %}
{% endif %}

