# SimRacing Hub OS — container image definition
# A Linux distribution for sim racing, built on Bazzite (GNOME, Nvidia).
#
# Built automatically by GitHub Actions. See .github/workflows/.

FROM ghcr.io/ublue-os/bazzite-gnome-nvidia-open:stable

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
#   wine + winetricks -> groundwork for SimHub (cabextract is already in base)
#   obs-studio        -> recording & streaming
#   firefox           -> web browser
#   nextcloud-client  -> Nextcloud file sync
#   gimp              -> image editing
# FreeCAD is not in Fedora's repos here, so it ships as a Flatpak (see below).
RUN dnf5 install -y \
        wine \
        winetricks \
        obs-studio \
        firefox \
        nextcloud-client \
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

# --- Claude Desktop helper --------------------------------------------------
COPY scripts/claude-desktop-setup.sh /usr/bin/claude-desktop-setup
RUN chmod +x /usr/bin/claude-desktop-setup && \
    printf '%s\n' \
      '[Desktop Entry]' \
      'Type=Application' \
      'Name=Install Claude Desktop' \
      'Comment=Install the community-built Claude Desktop for Linux' \
      'Exec=claude-desktop-setup' \
      'Icon=application-x-executable' \
      'Terminal=true' \
      'Categories=Utility;Network;' \
      > /usr/share/applications/simracinghub-claude-desktop-setup.desktop

# --- Default Flatpaks (installed on first boot) ----------------------------
# Betterbird (email), LocalSend, OrcaSlicer and FreeCAD are not in Fedora's
# repos but are on Flathub. Flatpaks live under /var, which is not part of the
# image, so a one-shot service installs them the first time the system boots.
# It only marks itself done on success, so it retries if there is no network yet.
RUN printf '%s\n' \
      '#!/usr/bin/bash' \
      'set -euo pipefail' \
      'flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo' \
      'flatpak install -y --noninteractive flathub eu.betterbird.Betterbird org.localsend.localsend_app com.orcaslicer.OrcaSlicer org.freecad.FreeCAD' \
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
      > /usr/lib/systemd/system/simracinghub-flatpaks.service && \
    systemctl enable simracinghub-flatpaks.service

# --- Branding: wallpaper & logo --------------------------------------------
COPY branding/simracinghub-os-wallpaper.svg /usr/share/backgrounds/simracinghub-os/simracinghub-os.svg
COPY branding/simracinghub-os-logo.svg /usr/share/icons/hicolor/scalable/apps/simracinghub-os.svg
RUN mkdir -p /usr/share/gnome-background-properties && \
    printf '%s\n' \
      '[org.gnome.desktop.background]' \
      'picture-uri="file:///usr/share/backgrounds/simracinghub-os/simracinghub-os.svg"' \
      'picture-uri-dark="file:///usr/share/backgrounds/simracinghub-os/simracinghub-os.svg"' \
      'picture-options="zoom"' \
      'primary-color="#0a0a0f"' \
      '' \
      '[org.gnome.desktop.screensaver]' \
      'picture-uri="file:///usr/share/backgrounds/simracinghub-os/simracinghub-os.svg"' \
      'primary-color="#0a0a0f"' \
      '' \
      '[org.gnome.login-screen]' \
      'logo="/usr/share/icons/hicolor/scalable/apps/simracinghub-os.svg"' \
      > /usr/share/glib-2.0/schemas/zz1-simracinghub-os.gschema.override && \
    glib-compile-schemas /usr/share/glib-2.0/schemas/ && \
    printf '%s\n' \
      '<?xml version="1.0" encoding="UTF-8"?>' \
      '<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">' \
      '<wallpapers>' \
      '  <wallpaper deleted="false">' \
      '    <name>SimRacing Hub OS</name>' \
      '    <filename>/usr/share/backgrounds/simracinghub-os/simracinghub-os.svg</filename>' \
      '    <options>zoom</options>' \
      '    <pcolor>#0a0a0f</pcolor>' \
      '    <scolor>#0a0a0f</scolor>' \
      '  </wallpaper>' \
      '</wallpapers>' \
      > /usr/share/gnome-background-properties/simracinghub-os.xml && \
    ostree container commit
