# Package

version       = "0.1.0"
author        = "hugosenari"
description   = "cassandra client"
license       = "MIT"
srcDir        = "src"
bin           = @["cascli"]


# Dependencies

requires "nim >= 2.0.0"
requires "cassandra"
