{ lib, ... }:
with lib;
let
  rgbToHex = rgb: foldl (acc: v: acc + v) "#" (map (v: fixedWidthString 2 "0" (toHexString v)) rgb);
  mapColorAttrset = mapAttrsRecursive (p: v: if isList v && length v == 3 then rgbToHex v else v);
in
mapColorAttrset {
  default = {
    blue = [
      0
      122
      255
    ];
    brown = [
      162
      132
      94
    ];
    cyan = [
      85
      190
      240
    ];
    gray = [
      142
      142
      147
    ];
    green = [
      40
      205
      65
    ];
    indigo = [
      88
      86
      214
    ];
    mint = [
      0
      199
      190
    ];
    orange = [
      255
      149
      0
    ];
    pink = [
      255
      45
      85
    ];
    purple = [
      175
      82
      222
    ];
    red = [
      255
      59
      48
    ];
    teal = [
      89
      173
      196
    ];
    yellow = [
      255
      204
      0
    ];
  };

  grays = {
    light = {
      gray = [
        142
        142
        147
      ];
      gray2 = [
        174
        174
        178
      ];
      gray3 = [
        199
        199
        204
      ];
      gray4 = [
        209
        209
        214
      ];
      gray5 = [
        229
        229
        234
      ];
      gray6 = [
        242
        242
        247
      ];
    };
    dark = {
      gray = [
        142
        142
        147
      ];
      gray2 = [
        99
        99
        102
      ];
      gray3 = [
        72
        72
        74
      ];
      gray4 = [
        58
        58
        60
      ];
      gray5 = [
        44
        44
        46
      ];
      gray6 = [
        28
        28
        30
      ];
    };
  };

  spotify = "#1DB954";
}
