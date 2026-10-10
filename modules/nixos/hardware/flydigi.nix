{ pkgs, ... }:
{
  # uaccess ACLs are applied by 73-seat-late.rules, so the tag has to come from
  # a rules file that sorts before it rather than from extraRules (99-local).
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "flydigi-udev-rules";
      destination = "/etc/udev/rules.d/70-flydigi.rules";
      text = ''
        # Flydigi Space Station web configurator (WebHID/WebUSB)
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="37d7", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTR{idVendor}=="37d7", TAG+="uaccess"

        # Vader 5 Pro: SDL drives the vendor HID interface, so the XInput
        # interface only ever yields a duplicate "Generic X-Box pad".
        ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_interface", ATTRS{idVendor}=="37d7", ATTRS{idProduct}=="2401", ATTR{bInterfaceNumber}=="00", ATTR{authorized}="0"
      '';
    })
  ];
}
