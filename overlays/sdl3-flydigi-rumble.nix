# SDL's Flydigi driver hands rumble packets to the generic HIDAPI rumble thread,
# which writes them verbatim with the report-ID byte in front. The Vader 5 Pro
# uses unnumbered reports and silently drops such packets.
# Upstream: https://github.com/libsdl-org/SDL/issues/16187
# Kept as a separate package: sdl2-compat links sdl3, so patching sdl3 itself
# rebuilds every SDL2 consumer. The Steam client loads it via SDL3_DYNAMIC_API;
# nothing else reaches its dlmopen namespace, and replacing the file trips
# Steam's size verifier. The override is rejected when older than the caller,
# and Steam bundles SDL from main (3.5.0-dev), so this must stay at or past the
# revision Steam reports in logs/console-linux.txt.
_: prev: {
  sdl3-flydigi-rumble = prev.sdl3.overrideAttrs (old: {
    version = "3.5.0-unstable-2026-10-13";
    src = prev.fetchFromGitHub {
      owner = "libsdl-org";
      repo = "SDL";
      rev = "ab5541ec5d4377dcc20a701897437f07ba71566f";
      hash = "sha256-G8u68c03zA7y3bu7CeTXlWg6u3xkj5krTLIFwOczBXk=";
    };
    patches = (old.patches or [ ]) ++ [
      ./patches/sdl3-flydigi-vader5-rumble.patch
      ./patches/sdl3-flydigi-trigger-rumble.patch
    ];
    doCheck = false;
  });
}
