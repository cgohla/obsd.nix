{
  description = "OpenBSD 7.3 VM image";

  inputs = {
    installImage = {
      url = "https://cdn.openbsd.org/pub/OpenBSD/7.3/amd64/install73.iso";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, installImage }: {

    packages.x86_64-linux.default = self.packages.x86_64-linux.obsd73;

    packages.x86_64-linux.obsd73 = with import nixpkgs { system = "x86_64-linux"; };
      let
        targetImage = "vm.qcow2";
        outputPath = "$out/share";
        diskSize = "30G";
        hostname = "bender";
        username = "jdoe";
        userFullName = "John Doe";
        userPassword = "badpassword";
        rootPassword = "badpassword";
        prepImage = "prepImage.sh";
      in
      stdenv.mkDerivation {
        name = "obsd73";
        src = self;
        buildPhase = ''
                     echo building a qcow VM image from install medium: ${installImage}
                     ${qemu}/bin/qemu-img create -f qcow2 ${targetImage} ${diskSize}

                     cat > script.exp <<END
                     spawn ${qemu}/bin/qemu-system-x86_64 -no-reboot -enable-kvm -nographic -drive file=${targetImage},if=virtio -cdrom ${installImage}
                     expect "boot>"
                     send "set tty com0\n"
                     expect "boot>"
                     send "boot\n"
                     expect "Welcome to the OpenBSD/amd64 7.3 installation program."
                     expect "(I)nstall, (U)pgrade, (A)utoinstall or (S)hell?"
                     send "I\n"
                     expect "Terminal type?"
                     send "\n"
                     expect "System hostname?"
                     send "${hostname}\n"
                     expect "Network interface to configure?"
                     send "\n"
                     expect "IPv4 address for em0?"
                     send "\n"
                     expect "IPv6 address for em0?"
                     send "\n"
                     expect "Network interface to configure?"
                     send "\n"
                     expect "Password for root account?"
                     send "${rootPassword}\n"
                     expect "Password for root account?"
                     send "${rootPassword}\n"
                     expect "Start sshd(8) by default?"
                     send "\n"
                     expect "Do you expect to run the X Window System?"
                     send "no\n"
                     expect "Change the default console to com0?"
                     send "\n"
                     expect "Which speed should com0 use?"
                     send "\n"
                     expect "Setup a user?"
                     send "${username}\n"
                     expect "Full name for user jdoe?"
                     send "${userFullName}\n"
                     expect "Password for user jdoe?"
                     send "${userPassword}\n"
                     expect "Password for user jdoe?"
                     send "${userPassword}\n"
                     expect "Allow root ssh login?"
                     send "no\n"
                     expect "installing"
                     expect "Encrypt the root disk?"
                     send "no\n"
                     expect "Which disk is the root disk?"
                     send "sd0\n"
                     expect "Use (W)hole disk MBR, whole disk (G)PT or (E)dit?"
                     send "W\n"
                     expect "Use (A)uto layout, (E)dit auto layout, or create (C)ustom layout?"
                     send "A\n"
                     expect "Location of sets?"
                     send "\n"
                     expect "Pathname to the sets?"
                     send "\n"
                     expect "Set name(s)? (or 'abort' or 'done')"
                     send -- "-x*\n"
                     expect "Set name(s)? (or 'abort' or 'done')"
                     send -- "-g*\n"
                     expect "Set name(s)? (or 'abort' or 'done')"
                     send "\n"
                     expect "Directory does not contain SHA256.sig. Continue without verification?"
                     send "yes\n"
                     expect -timeout 600 "Location of sets?"
                     send "\n"
                     expect "What timezone are you in?"
                     send "\n"
                     expect "Exit to (S)hell, (H)alt or (R)eboot?"
                     send "S\n"
                     expect "#"
                     send "sync\n"
                     expect "#"
                     send "halt\n"
                     expect "The operating system has halted"
                     END
                     ${expect}/bin/expect script.exp

                     cat > ${prepImage} <<END
                     #!/usr/bin/env bash
                     # this should probably be a funcion in the dev shell
                     [[ \$# = 1 ]] || (echo "usage: \$0 VM_NAME" && exit 1)

                     VM_NAME="\$1"
                     # ${qemu}/bin/qemu-img create -f qcow2 -b ${outputPath}/${targetImage} -F qcow2 "\$VM_NAME" ${diskSize}
                     cp ${outputPath}/${targetImage} "\$VM_NAME"
                     chmod a=rw "\$VM_NAME"
                     END
                     '';

        installPhase = ''
                     mkdir -p ${outputPath}
                     install ${targetImage} ${outputPath}/${targetImage}
                     mkdir -p $out/bin
                     install -m a+rx ${prepImage} $out/bin/${prepImage}
                     '';
      };
  };
}
