{ 
  cassandra-cpp-driver
, cassandra-nim
, lsb ? false
, nimPackages
, patchelf
}:
nimPackages.buildNimPackage ({
  pname       = "cascli";
  version     = "0.1.0";
  src         = ./.;
  nimBinOnly  = true;
  buildInputs = [ cassandra-nim patchelf ];
} // (if lsb then {
  nimFlags     = ["-d:lsb=on"];
  fixupPhase   = ''
    echo "libcassandra © Datastax, licensed with APL 2.0 https://github.com/datastax/cpp-driver/blob/master/LICENSE.txt" \
      >> $out/bin/LICENCE.txt
    cp ${cassandra-cpp-driver}/lib/libcassandra.so.2.*\
      $out/bin/
    cd $out/bin/
    ln -s  libcassandra.so.2.* libcassandra.so
    ln -s  libcassandra.so.2.* libcassandra.so.2
    cd -
    patchelf \
      --set-interpreter /lib64/ld-linux-x86-64.so.2 \
      $out/bin/cascli
    patchelf \
      --set-rpath '$ORIGIN:$ORIGIN/../lib64:/lib64:/usb/lib64' \
      $out/bin/cascli
    mv $out/bin $out/cascli
    cp *.example $out/cascli/
    cd $out
    tar -czvf $out/cascli.tar.gz cascli
    cd -
  '';
} else {}))
