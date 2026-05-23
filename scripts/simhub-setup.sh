#!/usr/bin/bash
#
# SimRacing Hub OS — SimHub setup helper
#
# STATUS: placeholder scaffold (Phase 2).
# The working version arrives in Phase 4, once Wine is layered into the image.
#
# Planned behaviour:
#   1. Create a dedicated Wine prefix:
#        ~/.local/share/simracinghub-os/simhub-prefix
#   2. Install the .NET 4.8 runtime into the prefix (winetricks dotnet48).
#   3. Acquire the current SimHub installer from the official site.
#      (SimHub's installer cannot be redistributed inside the image, so it is
#       fetched on first run instead of being baked in.)
#   4. Install SimHub into the prefix.
#   5. Register the launcher (see simhub-launch.sh) and a desktop entry.
#
# Confirmed-working hardware under this approach:
#   - bass shakers via a sound card
#   - wind simulators / motion via Arduino

set -euo pipefail

echo "SimRacing Hub OS — SimHub setup"
echo
echo "This helper is not active yet — it is enabled in a later build (Phase 4)."
echo "See the project Design & Build Plan for details."
exit 0
