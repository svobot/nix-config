# rocm-smi only looks for pci.ids at FHS paths, so on NixOS the GPU name
# degrades to the raw vendor ID (0x1002).
final: prev: {
  btop-rocm = prev.btop-rocm.override {
    rocmPackages = prev.rocmPackages // {
      rocm-smi = prev.rocmPackages.rocm-smi.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace src/rocm_smi.cc \
            --replace-fail "/usr/share/hwdata/pci.ids" "${final.hwdata}/share/hwdata/pci.ids"
        '';
      });
    };
  };
}
