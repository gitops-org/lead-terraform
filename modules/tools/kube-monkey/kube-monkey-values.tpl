replicaCount: 1
image:
  repository: ayushsobti/kube-monkey
  tag: ${app_version}
  pullPolicy: IfNotPresent
config:
  dryRun: false
  runHour: ${run_hour}
  startHour: ${start_hour}
  endHour: ${end_hour}
  blacklistedNamespaces: [ "kube-system", "monitoring" ]
  whitelistedNamespaces: [ "toolchain" ]
  timeZone: ${timezone}
args:
  logLevel: 5
  logDir: /var/log/kube-monkey