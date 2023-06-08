# obsd.nix
Nix expression for OpenBSD VMs.

The build result is a qcow2 image for x86_64.

## WARNING
Don't use this in production: the VM has a known root password.

## How to use
- todo

## Caveats
- We can't guarantee bit for bit reproducibility, because the image
  will contain timestamps. 
- The image as built is read-only of course, so to use it in any
  meaningful way, you need to copy it.
- The expect script running the installation is probably fragile. 
- We hit a segmentation fault when installing GHC using `pkg_add`.
