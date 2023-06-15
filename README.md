# obsd.nix
Nix expression for OpenBSD VMs.

The build result is a qcow2 image for x86_64.

## WARNING
Don't use this in production: the VM has a known root password.

## How to use
- Run
  ```shell
  $ nix develop github.com:cgohla/obsd.nix
  $ prepImage.sh myobsdvm.qcow2 # creates a copy-on-write instance in the current directory
  $ runImage.sh myobsdvm.qcow2 # boots the VM
  ```

- Get started

  Note this will download the OpenBSD installer CD, which is about
  600MB big.

  When you boot the VM, you will be connected to the serial console of
  the guest system.

  The system has `root` and `jdoe` accounts, both with password
  `badpassword`.

  The VM has user level network access, so it can access the host
  network. But as it is, it can not be used to host services.

  QEMU can be stopped by typing `C-a x`, but this is like turning the
  power off. If you want an orderly shutdown, log in as root as run
  `halt`.

## Caveats
- We can't guarantee bit for bit reproducibility, because the image
  will contain timestamps.
- The image as built is read-only of course, so to use it in any
  meaningful way, you need to copy it, hence the `prepImage.sh`
  script.
- The expect script running the installation is probably fragile.
