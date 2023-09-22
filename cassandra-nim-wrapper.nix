{ 
    cassandra-cpp-driver
  , nimbleLock
  , nimPackages
}:
let cassInfo = nimbleLock.packages.cassandra;
in
nimPackages.buildNimPackage {
  doCheck = false;
  pname   = "casandra";
  version = cassInfo.version;
  src     = builtins.fetchGit {
    url     = cassInfo.url;
    rev     = cassInfo.vcsRevision;
    ref     = "master";
  };
  propagatedBuildInputs = [ cassandra-cpp-driver ];
}
