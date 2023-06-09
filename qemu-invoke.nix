{ qemu
, vmImage
, graphics ? false
, reboot ? false
, cdromImage ? null
, enableKvm ? true
, memory ? "4G"
, cpu ? null
, cores ? null
}:
let
  options = {
    qemuExec = "${qemu}/bin/qemu-system-x86_64";
    memory = "-m ${memory}";
    cpu = if isNull cpu then "" else "-cpu ${cpu}";
    smp = if isNull cores then "" else "-smp cpus=${cores}";
    reboot = if reboot then "" else "-no-reboot";
    graphics = if graphics then "" else "-nographic";
    enableKvm = if enableKvm then "-enable-kvm" else "";
    drive = "-drive file=${vmImage},if=virtio";
    cdrom = if isNull cdromImage then "" else "-cdrom ${cdromImage}";
  };
in
''
  ${options.qemuExec} ${options.memory} ${options.cpu} ${options.smp} ${options.reboot} ${options.graphics} ${options.enableKvm} ${options.drive} ${options.cdrom}
''
