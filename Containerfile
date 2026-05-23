# SimRacing Hub OS — container image definition
# A Linux distribution for sim racing, built on Bazzite (GNOME).
#
# Built automatically by GitHub Actions. See .github/workflows/.

FROM ghcr.io/ublue-os/bazzite-gnome:stable

LABEL org.opencontainers.image.title="SimRacing Hub OS"
LABEL org.opencontainers.image.description="A Linux distribution for sim racing, built on Bazzite."
LABEL org.opencontainers.image.vendor="SimRacing Hub"
LABEL org.opencontainers.image.source="https://github.com/halvar20000/simracinghub-os"

# --- Phase 2: identity ------------------------------------------------------
# Make the OS report itself as "SimRacing Hub OS".
RUN sed -i \
      -e 's/^NAME=.*/NAME="SimRacing Hub OS"/' \
      -e 's/^PRETTY_NAME=.*/PRETTY_NAME="SimRacing Hub OS"/' \
      /usr/lib/os-release

# --- Phase 3: sim racing software ------------------------------------------
# Steam, Proton and GE-Proton already ship with Bazzite.
# Added here:
#   wine + winetricks -> groundwork for SimHub (set up in Phase 4)
#   obs-studio        -> recording & streaming for YouTube
RUN dnf5 install -y \
        wine \
        winetricks \
        obs-studio && \
    dnf5 clean all && \
    ostree container commit
