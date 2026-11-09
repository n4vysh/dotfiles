echo 'INFO: Set Windows Wi-Fi MTU to 1280'
$ErrorActionPreference = 'Stop'
exit (Start-Process powershell.exe -Verb RunAs -Wait -PassThru `
  -ArgumentList '-NoProfile', '-Command', `
    "Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -NlMtuBytes 1280 -ErrorAction Stop").ExitCode
