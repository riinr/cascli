{
  # Name your shell environment
  devshell.name = "cascli";

  # create .gitignore
  files.gitignore.enable = true;
  # add hello.yaml to .gitignore
  # copy contents from https://github.com/github/gitignore
  # to our .gitignore
  files.gitignore.pattern.".*"               = true;
  files.gitignore.pattern."*.ini"            = true;
  files.gitignore.pattern."result"           = true;
  files.gitignore.template."Global/Archives" = true;
  files.gitignore.template."Global/Backup"   = true;
  files.gitignore.template."Global/Diff"     = true;

  # install a packages
  packages = [
    "cassandra-cpp-driver"
    "nim2"
    "patchelf"
    "binutils"
  ];

  # configure direnv .envrc file
  files.direnv.enable = true;

  env = [
    ## { name = "LD_LIBRARY_PATH"; eval = "$DEVSHELL_DIR/lib/"; }
    { name = "PKG_CONFIG_PATH"; eval = "$DEVSHELL_DIR/lib/pkgconfig/"; }
  ];
}
