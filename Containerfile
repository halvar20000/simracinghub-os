# SimRacing Hub OS — container image definition
# A Linux distribution for sim racing, built on Bazzite (GNOME).
#
# Built automatically by GitHub Actions. See .github/workflows/.

FROM ghcr.io/ublue-os/bazzite-gnome:stable

LABEL org.opencontainers.image.title="SimRacing Hub OS"
LABEL org.opencontainers.image.description="A Linux distribution for sim racing, built on Bazzite."
LABEL org.opencontainers.image.vendor="SimRacing Hub"
LABEL org.opencontainers.image.source="https://github.com/halvar20000/simracinghub-os"

# --- Identity ---------------------------------------------------------------
RUN sed -i \
      -e 's/^NAME=.*/NAME="SimRacing Hub OS"/' \
      -e 's/^PRETTY_NAME=.*/PRETTY_NAME="SimRacing Hub OS"/' \
      /usr/lib/os-release && \
    sed -i '/^LOGO=/d' /usr/lib/os-release && \
    echo 'LOGO=simracinghub-os' >> /usr/lib/os-release

# --- Software packages ------------------------------------------------------
# Steam, Proton and GE-Proton already ship with Bazzite.
#   wine + winetricks + cabextract -> groundwork for SimHub
#   obs-studio                     -> recording & streaming
#   firefox                        -> web browser
#   nextcloud-client               -> Nextcloud file sync
#   freecad                        -> parametric 3D CAD
#   gimp                           -> image editing
RUN dnf5 install -y \
        wine \
        winetricks \
        cabextract \
        obs-studio \
        firefox \
        nextcloud-client \
        freecad \
        gimp && \
    dnf5 clean all

# --- SimHub helper ----------------------------------------------------------
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
      > /usr/share/applications/simracinghub-simhub-setup.desktop

# --- Default Flatpaks (installed on first boot) ----------------------------
# Betterbird (email), LocalSend and OrcaSlicer are not in Fedora's repos but
# are on Flathub. Flatpaks live under /var, which is not part of the image,
# so a one-shot service installs them the first time the system boots. It
# only marks itself done on success, so it retries if there is no network yet.
RUN printf '%s\n' \
      '#!/usr/bin/bash' \
      'set -euo pipefail' \
      'flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo' \
      'flatpak install -y --noninteractive flathub eu.betterbird.Betterbird org.localsend.localsend_app com.orcaslicer.OrcaSlicer' \
      'mkdir -p /var/lib/simracinghub-os' \
      'touch /var/lib/simracinghub-os/flatpaks-installed' \
      > /usr/libexec/simracinghub-install-flatpaks && \
    chmod +x /usr/libexec/simracinghub-install-flatpaks && \
    printf '%s\n' \
      '[Unit]' \
      'Description=Install SimRacing Hub OS default Flatpaks' \
      'After=network-online.target' \
      'Wants=network-online.target' \
      'ConditionPathExists=!/var/lib/simracinghub-os/flatpaks-installed' \
      '' \
      '[Service]' \
      'Type=oneshot' \
      'ExecStart=/usr/libexec/simracinghub-install-flatpaks' \
      'RemainAfterExit=yes' \
      '' \
      '[Install]' \
      'WantedBy=multi-user.target' \
      > /us
