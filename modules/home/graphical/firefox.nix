{
  config,
  lib,
  pkgs,
  ...
}:
let
  leptonCssDir = "${pkgs.firefox-ui-fix}/chrome/css";
  lepton = {
    # synced for v8.6.1
    required = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "svg.context-properties.content.enabled" = true;
      "browser.compactmode.show" = true;
      "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;
      "layout.css.has-selector.enabled" = true;

      # "layout.css.prefers-color-scheme.content-override" = 3;
    };

    theme = {
      "userChrome.tab.connect_to_window" = true; # Original, Photon
      "userChrome.tab.color_like_toolbar" = true; # Original, Photon

      "userChrome.tab.lepton_like_padding" = false; # Original
      "userChrome.tab.photon_like_padding" = true; # Photon

      "userChrome.tab.dynamic_separator" = false; # Original, Proton
      "userChrome.tab.static_separator" = true; # Photon
      "userChrome.tab.static_separator.selected_accent" = false; # Just option
      "userChrome.tab.bar_separator" = false; # Just option

      "userChrome.tab.newtab_button_like_tab" = false; # Original
      "userChrome.tab.newtab_button_smaller" = false; # Photon
      "userChrome.tab.newtab_button_proton" = true; # Proton

      "userChrome.icon.panel_full" = false; # Original, Proton
      "userChrome.icon.panel_photon" = true; # Photon

      # Original Only
      "userChrome.tab.box_shadow" = false;
      "userChrome.tab.bottom_rounded_corner" = false;

      # Photon Only
      "userChrome.tab.photon_like_contextline" = true;
      "userChrome.rounding.square_tab" = true;
    };

    compatibility = {
      # "userChrome.compatibility.accent_color" = true; # Firefox v103 Below
      # "userChrome.compatibility.covered_header_image" = true;
      # "userChrome.compatibility.panel_cutoff" = true;
      # "userChrome.compatibility.navbar_top_border" = true;
      # "userChrome.compatibility.dynamic_separator" = true; # Need dynamic_separator

      # "userChrome.compatibility.os.linux_non_native_titlebar_button" = true;
      # "userChrome.compatibility.os.windows_maximized" = true;
      # "userChrome.compatibility.os.win11" = true;
    };

    custom = {
      # User Chrome
      # "userChrome.theme.private" = true;
      # "userChrome.theme.proton_color.dark_blue_accent" = true;
      # "userChrome.theme.monospace" = true;
      # "userChrome.theme.transparent.frame" = true;
      # "userChrome.theme.transparent.menu" = true;
      # "userChrome.theme.transparent.panel" = true;
      # "userChrome.theme.non_native_menu" = true; # only for linux

      "userChrome.decoration.disable_panel_animate" = true;
      "userChrome.decoration.disable_sidebar_animate" = true;
      # "userChrome.decoration.panel_button_separator" = true;
      # "userChrome.decoration.panel_arrow" = true;

      # "userChrome.autohide.tab" = true;
      # "userChrome.autohide.tab.opacity" = true;
      # "userChrome.autohide.tab.blur" = true;
      # "userChrome.autohide.tabbar" = true;
      # "userChrome.autohide.navbar" = true;
      # "userChrome.hidden.private_indicator" = true;
      # "userChrome.autohide.bookmarkbar" = true;
      # "userChrome.autohide.sidebar" = true;
      # "userChrome.autohide.fill_urlbar" = true;
      # "userChrome.autohide.back_button" = true;
      # "userChrome.autohide.forward_button" = true;
      # "userChrome.autohide.page_action" = true;
      # "userChrome.autohide.toolbar_overlap" = true;
      # "userChrome.autohide.toolbar_overlap.allow_layout_shift" = true;

      # "userChrome.hidden.tab_icon" = true;
      # "userChrome.hidden.tab_icon.always" = true;
      # "userChrome.hidden.tabbar" = true;
      # "userChrome.hidden.navbar" = true;
      # "userChrome.hidden.titlebar_container" = true;
      # "userChrome.hidden.sidebar_header" = true;
      # "userChrome.hidden.sidebar_header.vertical_tab_only" = true;
      # "userChrome.hidden.urlbar_iconbox" = true;
      # "userChrome.hidden.urlbar_iconbox.label_only" = true;
      # "userChrome.hidden.bookmarkbar_icon" = true;
      # "userChrome.hidden.bookmarkbar_label" = true;
      # "userChrome.hidden.disabled_menu" = true;

      # "userChrome.centered.tab" = true;
      # "userChrome.centered.tab.label" = true;
      # "userChrome.centered.urlbar" = true;
      # "userChrome.centered.bookmarkbar" = true;

      # "userChrome.counter.tab" = true;
      # "userChrome.counter.bookmark_menu" = true;

      # "userChrome.combined.nav_button" = true;
      # "userChrome.combined.nav_button.home_button" = true;
      # "userChrome.combined.urlbar.nav_button" = true;
      # "userChrome.combined.urlbar.home_button" = true;
      # "userChrome.combined.urlbar.reload_button" = true;
      # "userChrome.combined.sub_button.none_background" = true;
      # "userChrome.combined.sub_button.as_normal" = true;

      "userChrome.rounding.square_button" = true;
      "userChrome.rounding.square_dialog" = true;
      "userChrome.rounding.square_panel" = true;
      "userChrome.rounding.square_panelitem" = true;
      "userChrome.rounding.square_menupopup" = true;
      "userChrome.rounding.square_menuitem" = true;
      "userChrome.rounding.square_infobox" = true;
      "userChrome.rounding.square_toolbar" = true;
      "userChrome.rounding.square_field" = true;
      "userChrome.rounding.square_urlView_item" = true;
      "userChrome.rounding.square_checklabel" = true;

      # "userChrome.padding.first_tab" = true;
      # "userChrome.padding.first_tab.always" = true;
      # "userChrome.padding.drag_space" = true;
      # "userChrome.padding.drag_space.maximized" = true;

      # "userChrome.padding.toolbar_button.compact" = true;
      # "userChrome.padding.menu_compact" = true;
      # "userChrome.padding.bookmark_menu.compact" = true;
      # "userChrome.padding.urlView_expanding" = true;
      # "userChrome.padding.urlView_result" = true;
      # "userChrome.padding.panel_header" = true;

      # "userChrome.urlbar.iconbox_with_separator" = true;

      # "userChrome.urlView.as_commandbar" = true;
      # "userChrome.urlView.full_width_padding" = true;
      # "userChrome.urlView.always_show_page_actions" = true;
      # "userChrome.urlView.move_icon_to_left" = true;
      # "userChrome.urlView.go_button_when_typing" = true;
      # "userChrome.urlView.focus_item_border" = true;

      # "userChrome.tabbar.as_titlebar" = true;
      # "userChrome.tabbar.fill_width" = true;
      # "userChrome.tabbar.multi_row" = true;
      # "userChrome.tabbar.unscroll" = true;
      # "userChrome.tabbar.on_bottom" = true;
      # "userChrome.tabbar.on_bottom.above_bookmark" = true; # Need on_bottom
      # "userChrome.tabbar.on_bottom.menubar_on_top" = true; # Need on_bottom
      # "userChrome.tabbar.on_bottom.hidden_single_tab" = true; # Need on_bottom
      # "userChrome.tabbar.one_liner" = true;
      # "userChrome.tabbar.one_liner.combine_navbar" = true; # Need one_liner
      # "userChrome.tabbar.one_liner.tabbar_first" = true; # Need one_liner
      # "userChrome.tabbar.one_liner.responsive" = true; # Need one_liner

      # "userChrome.tab.bottom_rounded_corner.all" = true;
      # "userChrome.tab.bottom_rounded_corner.australis" = true;
      # "userChrome.tab.bottom_rounded_corner.edge" = true;
      # "userChrome.tab.bottom_rounded_corner.chrome" = true;
      # "userChrome.tab.bottom_rounded_corner.chrome_legacy" = true;
      # "userChrome.tab.bottom_rounded_corner.wave" = true;
      # "userChrome.tab.always_show_tab_icon" = true;
      # "userChrome.tab.close_button_at_pinned" = true;
      # "userChrome.tab.close_button_at_pinned.always" = true;
      # "userChrome.tab.close_button_at_pinned.background" = true;
      # "userChrome.tab.close_button_at_hover.always" = true; # Need close_button_at_hover
      # "userChrome.tab.close_button_at_hover.with_selected" = true; # Need close_button_at_hover
      # "userChrome.tab.sound_show_label" = true; # Need remove sound_hide_label
      # "userChrome.tab.container.on_top" = true;
      # "userChrome.tab.container.always_long" = true;
      # "userChrome.tab.sound_with_favicons.on_center" = true;
      # "userChrome.tab.selected_bold" = true;

      # "userChrome.navbar.as_sidebar" = true;

      # "userChrome.bookmarkbar.multi_row" = true;

      # "userChrome.findbar.floating_on_top" = true;

      # "userChrome.panel.remove_strip" = true;
      # "userChrome.panel.full_width_separator" = true;
      # "userChrome.panel.full_width_padding" = true;

      # "userChrome.sidebar.overlap" = true;

      # "userChrome.icon.disabled" = true;
      # "userChrome.icon.account_image_to_right" = true;
      # "userChrome.icon.account_label_to_right" = true;
      # "userChrome.icon.menu.full" = true;
      # "userChrome.icon.global_menu.mac" = true;

      # User Content
      # "userContent.player.ui.twoline" = true;

      # "userContent.newTab.hidden_logo" = true;
      # "userContent.newTab.background_image" = true; # Need wallpaper image to `userContent.css`. :root { --uc-newTab-wallpaper: url("../icons/background_image.png"); }

      # "userContent.page.proton_color.dark_blue_accent" = true;
      # "userContent.page.proton_color.system_accent" = true;
      # "userContent.page.dark_mode.pdf" = true;
      # "userContent.page.monospace" = true;
    };

    default = {
      # User Chrome
      "userChrome.compatibility.theme" = true;
      "userChrome.compatibility.os" = true;

      "userChrome.theme.built_in_contrast" = true;
      "userChrome.theme.system_default" = true;
      "userChrome.theme.proton_color" = true;
      "userChrome.theme.proton_chrome" = true; # Need proton_color
      "userChrome.theme.fully_color" = true; # Need proton_color
      "userChrome.theme.fully_dark" = true; # Need proton_color

      "userChrome.decoration.cursor" = true;
      "userChrome.decoration.field_border" = true;
      "userChrome.decoration.download_panel" = true;
      "userChrome.decoration.animate" = true;

      "userChrome.padding.tabbar_width" = true;
      "userChrome.padding.tabbar_height" = true;
      "userChrome.padding.toolbar_button" = true;
      "userChrome.padding.navbar_width" = true;
      "userChrome.padding.urlbar" = true;
      "userChrome.padding.bookmarkbar" = true;
      "userChrome.padding.infobar" = true;
      "userChrome.padding.menu" = true;
      "userChrome.padding.bookmark_menu" = true;
      "userChrome.padding.global_menubar" = true;
      "userChrome.padding.panel" = true;
      "userChrome.padding.popup_panel" = true;

      "userChrome.tab.multi_selected" = true;
      "userChrome.tab.unloaded" = true;
      "userChrome.tab.letters_cleary" = true;
      "userChrome.tab.close_button_at_hover" = false;
      "userChrome.tab.sound_hide_label" = true;
      "userChrome.tab.sound_with_favicons" = true;
      "userChrome.tab.pip" = true;
      "userChrome.tab.container" = true;
      "userChrome.tab.crashed" = true;

      "userChrome.fullscreen.overlap" = true;
      "userChrome.fullscreen.show_bookmarkbar" = true;

      "userChrome.icon.library" = true;
      "userChrome.icon.panel" = true;
      "userChrome.icon.menu" = true;
      "userChrome.icon.context_menu" = true;
      "userChrome.icon.global_menu" = true;
      "userChrome.icon.global_menubar" = true;
      "userChrome.icon.1-25px_stroke" = true;

      # User Content
      "userContent.player.ui" = true;
      "userContent.player.icon" = true;
      "userContent.player.noaudio" = true;
      "userContent.player.size" = true;
      "userContent.player.click_to_play" = true;
      "userContent.player.animate" = true;

      "userContent.newTab.full_icon" = true;
      "userContent.newTab.animate" = true;
      "userContent.newTab.pocket_to_last" = true;
      "userContent.newTab.searchbar" = true;

      "userContent.page.field_border" = true;
      "userContent.page.illustration" = true;
      "userContent.page.proton_color" = true;
      "userContent.page.dark_mode" = true; # Need proton_color
      "userContent.page.proton" = true; # Need proton_color

      "browser.urlbar.suggest.calculator" = true;
      "browser.urlbar.unitConversion.enabled" = true;

      # "browser.tabs.drawInTitlebar" = true;
      # "browser.tabs.inTitlebar" = 1; # Nightly, 96 Above
    };
  };

  defaultSettings = {
    "dom.event.contextmenu.enabled" = false; # Disable changes to context menu
    "dom.event.clipboardevents.enabled" = false; # Disable tracking copy, cut, paste, and selections
    "network.IDN_show_punycode" = true; # Show punycode

    # UI
    "browser.ctrlTab.sortByRecentlyUsed" = true;
    "browser.backspace_action" = 0; # Backspace goes back
    "browser.startup.page" = 3; # Resume the previous browser session
    "signon.rememberSignons" = false; # Don't ask to save passwords
    "browser.tabs.loadBookmarksInTabs" = true; # Open bookmarks in new tabs
    "browser.tabs.allowTabDetach" = false; # Don't create new windows by dragging tabs
    "browser.toolbars.bookmarks.visibility" = "never"; # Never show the bookmarks bar
    "browser.download.start_downloads_in_tmp_dir" = true; # Save to /tmp
    "browser.download.alwaysOpenPanel" = false; # Don't open the download pop-up every time
    "zoom.minPercent" = 100;
    "zoom.maxPercent" = 100;

    # Memory
    "browser.tabs.unloadOnLowMemory" = false;
    "browser.cache.disk.capacity" = 4194304; # 4GB

    # Warnings
    "browser.aboutConfig.showWarning" = false;
    "full-screen-api.warning.timeout" = 0;

    # DRM
    "media.gmp-widevinecdm.enabled" = false;
    "browser.eme.ui.enabled" = false;
  };

  centerNewTabShortcuts =
    # css
    ''
      @-moz-document url("about:home"), url("about:newtab") {
        body.activity-stream .nova-outer-wrapper {
          align-content: center !important;
          padding-block-start: 0 !important;
        }
        /* Minimal layout (logo + shortcuts only) reserves two empty 62.5px
           sidebar rows, so .content starts at grid-row 3 and the block lands
           below the real centre. Collapse the dead rows and pull it up. */
        body.activity-stream .nova-enabled.logo-in-content {
          grid-auto-rows: min-content !important;
        }
        body.activity-stream .nova-enabled.logo-in-content .content {
          grid-row: 1 !important;
        }
      }
    '';

  firefox-in-slice = pkgs.writeShellScript "firefox" ''
    exec ${pkgs.systemd}/bin/systemd-run \
      --user --slice=firefox.slice --scope --quiet --collect \
      -- ${config.programs.firefox.finalPackage}/bin/firefox "$@"
  '';
in
{
  home.file."${lib.removePrefix "${config.home.homeDirectory}/" config.xdg.binHome}/firefox".source =
    firefox-in-slice;
  home.sessionPath = [ config.xdg.binHome ];

  systemd.user.slices.firefox = {
    Unit.Description = "Firefox (memory-capped)";
    Slice = {
      MemoryHigh = "12G"; # soft cap: cold pages reclaimed into zram, tabs stay loaded
      MemoryMax = "15G"; # hard backstop: kills one content proc, not the system
      # MemorySwapMax is left at its default (infinity) so cold pages can offload
      # freely to zram — that free offload is the whole point of the soft cap.
    };
  };

  programs.firefox = {
    enable = true;
    # explicit config path to silence a home-manager < 26.05 warning.
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    profiles.default = {
      id = 0;
      settings = defaultSettings // lepton.required // lepton.theme // lepton.default // lepton.custom;

      userChrome = ''
        @import url("${leptonCssDir}/leptonChrome.css");
      '';

      userContent = ''
        @import url("${leptonCssDir}/leptonContent.css");

        ${centerNewTabShortcuts}
      '';
    };

    profiles.work = {
      id = 1;
      settings = defaultSettings // lepton.required // lepton.theme // lepton.default // lepton.custom;

      userChrome = ''
        @import url("${leptonCssDir}/leptonChrome.css");

        .browser-titlebar {background-color: rgb(241, 196, 15);}
        :root {
          background-color: rgb(241, 196, 15) !important;
        }
      '';

      userContent = ''
        @import url("${leptonCssDir}/leptonContent.css");

        ${centerNewTabShortcuts}
      '';
    };
  };

  xdg = {
    dataFile =
      let
        mkCappedFirefoxDesktop =
          {
            pname,
            filename,
            extraFlags ? "",
            wmName,
            displayName,
          }:
          pkgs.runCommand pname { } ''
            mkdir -p $out/share/applications
            substitute \
              ${config.programs.firefox.finalPackage}/share/applications/firefox.desktop \
              $out/share/applications/${filename} \
              --replace-fail 'Exec=firefox ' 'Exec=${firefox-in-slice} ${extraFlags}' \
              --replace-fail '--name firefox ' '--name ${wmName} ' \
              --replace-fail 'Name=Firefox' 'Name=${displayName}' \
              --replace-fail 'StartupWMClass=firefox' 'StartupWMClass=${wmName}'
          '';

        firefox-desktop-capped = mkCappedFirefoxDesktop {
          pname = "firefox-slice.desktop";
          filename = "firefox.desktop";
          wmName = "firefox";
          displayName = "Firefox";
        };

        firefox-work-desktop-capped = mkCappedFirefoxDesktop {
          pname = "firefox-work-slice.desktop";
          filename = "firefox-work.desktop";
          extraFlags = "-P work ";
          wmName = "firefox-work";
          displayName = "Firefox (Work)";
        };
      in
      {
        "applications/firefox.desktop".source =
          "${firefox-desktop-capped}/share/applications/firefox.desktop";
        "applications/firefox-work.desktop".source =
          "${firefox-work-desktop-capped}/share/applications/firefox-work.desktop";
      };

    mimeApps.defaultApplications = {
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };
}
