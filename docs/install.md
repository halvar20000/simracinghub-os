# Installing SimRacing Hub OS

> SimRacing Hub OS is in early development. Install it only on a test machine
> for now — not on a system you depend on.

## Two ways to install

### A. Rebase from an existing Bazzite install (easiest while testing)

If the test PC already runs Bazzite, switch it onto the SimRacing Hub OS
image with one command:

```bash
sudo bootc switch ghcr.io/halvar20000/simracinghub-os:latest
```

Reboot, and the machine now runs SimRacing Hub OS. To go back to plain
Bazzite at any time, rebase to the Bazzite image instead — nothing is lost.

On older Bazzite versions the equivalent command is:

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/halvar20000/simracinghub-os:latest
```

### B. Fresh install from an ISO

A standalone installable ISO is produced in Phase 7. Once available, you
flash it to a USB stick (with Fedora Media Writer, Balena Etcher, or
similar), boot from it, and install as normal.

## Updates

Once installed, SimRacing Hub OS **updates itself automatically** in the
background from the container registry. Each update is a complete, tested
image; if an update ever fails to boot, the system rolls back on its own to
the previous working version.

To check or trigger an update manually:

```bash
sudo bootc update
```

## Switching between desktop and Game Mode

At the login screen, use the session switcher to choose:

- **GNOME desktop** — the full daily-driver environment.
- **Game Mode** — the console-style sim racing appliance.

## Uninstalling

SimRacing Hub OS is just a Bazzite image with extras. Rebasing back to
Bazzite (or any other compatible image) fully reverts the system.
