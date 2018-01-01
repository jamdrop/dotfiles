#!/bin/bash

# gui toolkit stuff
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland-egl
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export ECORE_EVAS_ENGINE=wayland_egl
export ELM_DISPLAY=wl
export ELM_ACCEL=opengl


# wayland / sway config
export XKB_DEFAULT_LAYOUT=de
export WLC_SHM=1
export WLC_DRM_DEVICE=card0
sway --debug $@ 2>&1 | tee /tmp/sway.log
