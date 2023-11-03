{ 
  cassandra-cpp-driver
, cassandra-nim
, lsb ? false
, nimPackages
, patchelf
, binutils
, libuv
}:
nimPackages.buildNimPackage ({
  pname       = "cascli";
  version     = "0.1.0";
  src         = ./.;
  nimBinOnly  = true;
  buildInputs = [ cassandra-nim patchelf libuv binutils ];
} // (if lsb then {
  nimFlags     = ["-d:lsb=on"];
  fixupPhase   = ''
    printf "libcassandra © Datastax, licensed with APL 2.0 https://github.com/datastax/cpp-driver/blob/master/LICENSE.txt\n\n" \
      >> $out/bin/LICENCE.txt
    printf "libuv © libuv project,   licensed with MIT     https://github.com/libuv/libuv/blob/master/LICENSE\n\n" \
      >> $out/bin/LICENCE.txt

    cp ${cassandra-cpp-driver}/lib/libcassandra.so.2.*\
       $out/bin/
    cd $out/bin/
    ln -s  libcassandra.so.2.* libcassandra.so
    ln -s  libcassandra.so.2.* libcassandra.so.2
    cp ${libuv}/lib/libuv.so.1.0.*\
       $out/bin/
    ln -s  libuv.so.1.* libuv.so
    ln -s  libuv.so.1.* libuv.so.1
    cd -
    patchelf \
      --set-interpreter /lib64/ld-linux-x86-64.so.2 \
      $out/bin/cascli
    patchelf \
      --set-rpath '$ORIGIN:$ORIGIN/../lib64:/lib64:/usb/lib64' \
      $out/bin/cascli
    chmod ugo+rw $out/bin/*.so.2.* $out/bin/*.so.1.*
    strip $out/bin/cascli
    strip $out/bin/libuv.so.1.*
    strip $out/bin/libcassandra.so.2.*
    mv $out/bin $out/cascli
    cp *.example $out/cascli/
    cd $out
    tar -czvf   $out/cascli.tar.gz cascli
    cd -
    cat umbandr.sh              > $out/cascli.sh
    base64 $out/cascli.tar.gz >> $out/cascli.sh
    chmod +x $out/cascli.sh
  '';
} else {}))
