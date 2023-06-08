# obsd.nix
Nix expression for OpenBSD VMs.

The build result is a qcow2 image for x86_64.

## WARNING
Don't use this in production: the VM has a known root password.

## How to use
- run
  ```shell
  $ nix build github.com:cgohla/obsd.nix
  $ ./result/bin/prepImage.sh vm.qcow2
  $ nix-shell -p qemu --run "qemu-system-x86_64 -enable-kvm -smp cpus=8 -nographic -drive file=vm.qcow2,if=virtio"
  ```

  Note this will download the OpenBSD installer CD, which is about
  600MB big.

## Caveats
- We can't guarantee bit for bit reproducibility, because the image
  will contain timestamps.
- The image as built is read-only of course, so to use it in any
  meaningful way, you need to copy it, hence the `prepImage.sh`
  script.
- The expect script running the installation is probably fragile.
- There should probably a dev shell in this flake.
