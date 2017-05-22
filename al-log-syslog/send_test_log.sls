send_test_log:
  cmd.run:
    - name: logger -p daemon.info testing from {{ grains['fqdn'] }} by AL Agent test