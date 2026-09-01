Set-MpPreference -DisableRealtimeMonitoring $true

Set-NetFirewallProfile -Profile Domain, Private, Public -Enabled False
