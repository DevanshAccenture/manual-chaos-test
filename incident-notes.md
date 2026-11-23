# Incident Notes - Project 24: Manual Chaos Test

**Target:** devansh-p24-chaos (EC2, nginx)
**Date:** 2026-11-23 (UTC)

## Timeline
| Time (UTC) | Event |
|---|---|
| 12:46:11 | Baseline: nginx active, HTTP 200 |
| 12:46:43 | Failure injected: `systemctl stop nginx` |
| 12:46:43 | Impact: nginx inactive, HTTP 000 (connection refused) |
| 12:47:28 | Recovery: `systemctl start nginx` |
| 12:47:28 | Verified: nginx active, HTTP 200, page content correct |

## Summary
- Total outage window: about 45 seconds (manual restart)
- Root cause: service deliberately stopped (chaos test)
- Detection: curl returned HTTP 000, systemctl showed inactive
- Resolution: restarted the service with systemctl

## Lessons learned
- Run nginx under a systemd restart policy (Restart=always) so it self-heals
- Add a health check or CloudWatch alarm to detect an outage automatically
- Recovery was fast because the service was enabled and its config was intact
