#!/bin/bash
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland-egl
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export ECORE_EVAS_ENGINE=wayland_egl
export ELM_DISPLAY=wl
export ELM_ACCEL=opengl
export XKB_DEFAULT_LAYOUT=de
sway
