# SimRacing Hub OS — container image definition
# A Linux distribution for sim racing, built on Bazzite (GNOME).
#
# This image is built automatically by GitHub Actions and published to the
# GitHub Container Registry. See .github/workflows/build.yml.
#
# To build locally you need podman or buildah:
#   podman build -t simracinghub-os .

# --- Base image -------------------------------------------------------------
# bazzite-gnome:stable = Bazzite with the GNOME desktop.
# :stable is pinned for reliability; the weekly CI rebuild pulls upstream fixes.
FROM ghcr.io/ublue-os/bazzite-gnome:stable

# --- Image metadata ---------------------------------------------------------
LABEL org.opencontainers.image.title="SimRacing Hub OS"
LABEL org.opencontainers.image.description="A Linux distribution for sim racing, built on Bazzite."
LABEL org.opencontainers.image.vendor="SimRacing Hub"
LABEL org.opencontainers.image.source="https://github.com/halvar20000/simracinghub-os"

# --- Overlay files & build scripts ------------------------------------------
# system_files/  -> copied onto the image root (config, branding assets, udev)
# scripts/       -> helper scripts shipped to /usr/share/simracinghub-os/scripts
# build_files/   -> build-time only; deleted again after the build runs
COPY system_files /
COPY scripts /usr/share/simracinghub-os/scripts
COPY build_files /build_files

# --- Build ------------------------------------------------------------------
RUN /build_files/build.sh && \
    rm -rf /build_files && \
    ostree container commit

# --- Verify -----------------------------------------------------------------
# Confirms the result is a valid, bootable container image.
# If this is ever too strict on a first build it can be removed safely.
RUN bootc container lint
