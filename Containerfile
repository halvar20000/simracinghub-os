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
RUN sed -i \
      -e 's/^NAME=.*/NAME="SimRacing Hub OS"/' \
      -e 's/^PRETTY_NAME=.*/PRETTY_NAME="SimRacing Hub OS"/' \
      /usr/lib/os-release

# --- Phase 3: sim racing software ------------------------------------------
# Steam, Proton and GE-Proton already ship with Bazzite.
#   wine + winetricks + cabextract -> groundwork for SimHub
#   obs-studio                     -> recording & streaming for YouTube
RUN dnf5 install -y \
        wine \
        winetricks \
        cabextract \
        obs-studio && \
    dnf5 clean all

# --- Phase 4: SimHub helper -------------------------------------------------
# Ships the SimHub setup helper as the 'simhub-setup' command and adds a
# "Set Up SimHub" entry to the applications menu.
COPY scripts/simhub-setup.sh /usr/bin/simhub-setup
RUN chmod +x /usr/bin/simhub-setup && \
    printf '%s\n' \
      '[Desktop Entry]' \
      'Type=Application' \
      'Name=Set Up SimHub' \
      'Comment=Install and configure SimHub on SimRacing Hub OS' \
      'Exec=simhub-setup' \
      'Icon=application-x-executable' \
      'Terminal=true' \
      'Categories=Game;Settings;' \
      > /usr/share/applications/simracinghub-simhub-setup.desktop && \
    ostree container commit
