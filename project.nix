{
  # Name your shell environment
  devshell.name = "cascli";

  # create .gitignore
  files.gitignore.enable = true;
  # add hello.yaml to .gitignore
  # copy contents from https://github.com/github/gitignore
  # to our .gitignore
  files.gitignore.template."Global/Archives" = true;
  files.gitignore.template."Global/Backup"   = true;
  files.gitignore.template."Global/Diff"     = true;

  # install a packages
  packages = [
    "cassandra-cpp-driver"
    "nim2"
  ];

  # configure direnv .envrc file
  files.direnv.enable = true;
}
