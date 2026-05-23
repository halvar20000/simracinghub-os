#!/usr/bin/bash
#
# SimRacing Hub OS — image build script
# Runs inside the container build (invoked by the Containerfile).
#
# Phases are layered in over time; see the project Design & Build Plan.
# Keep each phase in its own clearly-marked block so the build stays readable.

set -euo pipefail

echo "::group:: SimRacing Hub OS — build"

# ===========================================================================
# Phase 2 — Identity / branding
# Make the OS report itself as "SimRacing Hub OS".
#
# Note: ID and VARIANT_ID are intentionally left as upstream so Bazzite's
# update tooling and bootc keep working. Only the display names are changed.
# ===========================================================================
echo "-> Applying SimRacing Hub OS identity"
sed -i \
    -e 's/^NAME=.*/NAME="SimRacing Hub OS"/' \
    -e 's/^PRETTY_NAME=.*/PRETTY_NAME="SimRacing Hub OS"/' \
    /usr/lib/os-release

# Make shipped helper scripts executable.
if [ -d /usr/share/simracinghub-os/scripts ]; then
    chmod -R +x /usr/share/simracinghub-os/scripts
fi

# ===========================================================================
# Phase 3 — Sim racing packages            (ENABLED IN A LATER BUILD)
# Bazzite already ships Steam, Proton, GE-Proton, Gamescope and MangoHud.
# Here we add the extras a sim racing distro needs.
# ===========================================================================
# dnf5 install -y \
#     wine \
#     winetricks \
#     obs-studio \
#     oversteer

# ===========================================================================
# Phase 4 — SimHub first-run helper         (ENABLED IN A LATER BUILD)
# Phase 5 — FFB drivers, telemetry, udev    (ENABLED IN A LATER BUILD)
# Phase 6 — Branding assets: splash, wallpapers, OBS preset   (LATER BUILD)
# ===========================================================================

echo "-> Build complete"
echo "::endgroup::"
