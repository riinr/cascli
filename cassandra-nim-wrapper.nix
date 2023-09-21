{ 
    cassandra-cpp-driver
  , fetchgit
  , nimbleLock
  , nimPackages
}:
let cassInfo = nimbleLock.packages.cassandra;
in
nimPackages.buildNimPackage {
  doCheck = false;
  pname   = "casandra";
  version = cassInfo.version;
  src     = fetchgit {
    url     = cassInfo.url;
    rev     = cassInfo.vcsRevision;

    hash    = "sha256:${cassInfo.checksums.sha256}";
  };
  propagatedBuildInputs = [ cassandra-cpp-driver ];
}
