# Hardware compatibility matrix

Results from testing sim racing hardware on SimRacing Hub OS. Filled in
during Phase 8. "Detected" means the device is seen by the OS; "Input" means
axes/buttons work in-game; "FFB" means force feedback works; "Config app"
notes whether the manufacturer's tuning software runs (most are Windows-only).

## Test rig hardware (Thomas's setup)

| Device | Type | Detected | Input | FFB | Config app | Notes |
|--------|------|----------|-------|-----|------------|-------|
| VNM Xtreme 32 Nm | Direct-drive wheelbase | TBD | TBD | TBD | TBD | Smaller brand — Linux status unknown, priority test |
| Simucube Active Pedal Pro | Active pedal | TBD | TBD | n/a | TBD | Active-pedal tuning likely Windows-only |
| Simagic P2000 | Load-cell pedals | TBD | TBD | n/a | TBD | Should work as standard HID axes |

## General notes

- Wheels and pedals normally work as **input devices** on Linux; force
  feedback depth and manufacturer tuning software are the weak spots.
- Where a tuning app is Windows-only, the fallback is: configure the device
  once on Windows, then race on Linux — most settings persist in the base's
  own firmware.
- Useful open-source tools: **Oversteer** (Logitech / Thrustmaster / Fanatec),
  **Boxflat** (Moza), **hid-fanatecff** (Fanatec FFB kernel driver).

## Community-tested hardware

| Device | Type | Result | Source |
|--------|------|--------|--------|
| _add entries as they are confirmed_ | | | |
