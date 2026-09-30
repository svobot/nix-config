{ pkgs, ... }:
{
  # Keep the proprietary font archive in the closure, otherwise garbage
  # collection removes the only copy and the next rebuild cannot fetch it.
  home.extraDependencies = [ pkgs.pragmata-pro.src ];

  home.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    apple-sf-pro
    apple-sf-compact
    apple-sf-mono
    apple-sf-arabic
    pragmata-pro
    (iosevka-bin.override { variant = "SS08"; })
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [
        "PragmataPro Mono Liga"
        "PragmataPro Liga"
      ];
      sansSerif = [
        "SF Pro Text"
        "SF Arabic"
        "Noto Sans"
      ];
      serif = [ "Noto Serif" ];
    };
    configFile.emoji-fallback = {
      enable = true;
      priority = 53;
      text =
        #xml
        ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
              <alias binding="weak">
                  <family>monospace</family>
                  <prefer>
                      <family>emoji</family>
                  </prefer>
              </alias>
              <alias binding="weak">
                  <family>sans-serif</family>
                  <prefer>
                      <family>emoji</family>
                  </prefer>
              </alias>
              <alias binding="weak">
                  <family>serif</family>
                  <prefer>
                      <family>emoji</family>
                  </prefer>
              </alias>
          </fontconfig>
        '';
    };
  };
}
