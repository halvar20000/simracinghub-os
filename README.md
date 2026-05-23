# SimRacing Hub OS

A Linux distribution for sim racing — built on [Bazzite](https://bazzite.gg).

Every major racing sim, SimHub, force-feedback hardware and a recording setup,
working out of the box. No ads, no bloat, no tracking — the SimRacing Hub
philosophy, as an operating system.

> **Status:** early development — Phase 2, repository scaffold.
> The image builds, boots and identifies as SimRacing Hub OS. Sim racing
> software is layered in over the following phases.

## What it is

- **Base:** Bazzite (GNOME) — Fedora atomic, gaming-tuned, with Steam,
  Proton and GE-Proton already on board.
- **Two modes:** a console-style Game Mode appliance *and* a full GNOME
  desktop, selectable at login — one machine, both jobs.
- **Built in the cloud:** every push is built by GitHub Actions and published
  as a container image. Installed systems then auto-update.

## A note on iRacing

iRacing does **not** run on Linux — its anti-cheat is not enabled for Linux by
iRacing, and no distribution can change that. iRacing users should keep a
small Windows dual-boot for it. Every other major sim — ACC, Assetto Corsa,
Automobilista 2, rFactor 2, Le Mans Ultimate, F1 — runs well through Proton.

Live status is tracked at [areweanticheatyet.com](https://areweanticheatyet.com).

## Install

See [docs/install.md](docs/install.md) for the full guide. In short, on an
existing Bazzite system:

```bash
sudo bootc switch ghcr.io/halvar20000/simracinghub-os:latest
```

A standalone installable ISO is produced in a later phase.

## How it is built

| Path | Purpose |
|------|---------|
| `Containerfile` | Defines the image — starts from Bazzite, layers our changes |
| `build_files/build.sh` | Build-time package installs and system tweaks |
| `system_files/` | Files overlaid onto the OS (config, branding, udev rules) |
| `scripts/` | Helper scripts shipped into the OS (e.g. SimHub setup) |
| `.github/workflows/build.yml` | GitHub Actions: build & publish the image |
| `docs/` | Install guide and the tested-hardware matrix |
| `branding/` | Source assets — logo, boot splash, wallpapers |

## Roadmap

| Phase | Work | Status |
|-------|------|--------|
| 1 | Design & build plan | Done |
| 2 | Repository scaffold | **Current** |
| 3 | Sim racing packages & gaming tweaks | Planned |
| 4 | SimHub first-run helper | Planned |
| 5 | FFB drivers, telemetry & hardware support | Planned |
| 6 | Branding — splash, wallpapers, OBS preset | Planned |
| 7 | CI publish to ghcr.io + installable ISO | Planned |
| 8 | Hardware testing & user documentation | Planned |

## License

Build scripts and configuration in this repository: MIT (see `LICENSE`).
Bazzite, Fedora and all bundled third-party software remain under their own
respective licenses.

---

*Part of the [SimRacing Hub](https://simracing-hub.com) project.*
