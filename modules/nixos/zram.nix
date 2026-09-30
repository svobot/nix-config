{
  boot.kernel.sysctl = {
    # High swappiness is intentional: it pairs with the zram swap below. It
    # lets the kernel evict cold anonymous pages (e.g. long-idle browser
    # tabs) into fast compressed zram, freeing physical RAM for active work
    # without unloading/discarding the tabs.
    # NOTE: only safe because zram is the highest-priority swap area. Do not
    # raise this on a host whose only swap is the disk swapfile.
    "vm.swappiness" = 180;
    # Swap-in readahead only pays off on rotational media; on zram each extra
    # page is a decompression that may never be needed.
    "vm.page-cluster" = 0;
  };

  zramSwap = {
    enable = true;
    # Capacity, not a reservation: a full device costs about a third of its
    # size in RAM at the observed zstd ratio.
    memoryPercent = 100;
    priority = 100;
  };
}
