# libwayland 1.24 made wl_display_dispatch() keep blocking until it has
# dispatched at least one event. mako polls on its own fds first, so a read that
# only carries events for objects it already destroyed parks it on the Wayland
# socket and starves D-Bus until the compositor happens to send something else.
# Upstream: https://github.com/emersion/mako/issues/636
_: prev: {
  mako = prev.mako.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./patches/mako-event-loop-prepare-read.patch ];
  });
}
