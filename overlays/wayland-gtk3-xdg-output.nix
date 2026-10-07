# GTK 3.24.52 frees a GdkWaylandMonitor when its wl_output global goes away but
# leaks the zxdg_output_v1 proxy, so the next xdg_output event (niri re-enabling
# eDP-1 after a lid toggle) lands in freed memory and kills every GTK3 client.
# Upstream: https://gitlab.gnome.org/GNOME/gtk/-/issues/8160, fixed on gtk-3-24
# by !10014 but in no release. Patching gtk3 itself would rebuild firefox,
# thunderbird and electron, and system.replaceDependencies needs IFD, which the
# evaluation-only CI cannot do, so the fixed build is spliced into the
# long-running clients one by one. The file name sorts after mako.nix on
# purpose: it has to wrap the patched mako.
final: prev:
let
  gtk3 = prev.gtk3.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./patches/gtk3-destroy-xdg-output-proxy.patch ];
  });

  withFixedGtk3 =
    drv:
    (final.replaceDirectDependencies {
      inherit drv;
      replacements = [
        {
          oldDependency = prev.gtk3;
          newDependency = gtk3;
        }
      ];
    }).overrideAttrs
      (_: {
        inherit (drv) meta;
        passthru = (drv.passthru or { }) // {
          inherit (drv) version;
        };
      });
in
{
  gtk3-xdg-output-fix = gtk3;

  firefox-unwrapped = withFixedGtk3 prev.firefox-unwrapped;
  thunderbird-unwrapped = withFixedGtk3 prev.thunderbird-unwrapped;
  mako = withFixedGtk3 prev.mako;
  polkit_gnome = withFixedGtk3 prev.polkit_gnome;
  xdg-desktop-portal-gtk = withFixedGtk3 prev.xdg-desktop-portal-gtk;
}
