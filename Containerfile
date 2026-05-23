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
RUN dnf5 install -y \
        wine \
        winetricks \
        cabextract \
        obs-studio && \
    dnf5 clean all

# --- Phase 4: SimHub helper -------------------------------------------------
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

# --- Phase 6: branding ------------------------------------------------------
# Ship the SimRacing Hub OS wallpaper and make it the default background.
COPY branding/simracinghub-os-wallpaper.svg /usr/share/backgrounds/simracinghub-os/simracinghub-os.svg
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
