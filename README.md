# Cascli

Dumb Cassandra Cli

It expect a query from stdin, we does this reduce string escape problems

```sh
 printf "SELECT cql_version FROM system.local"|./cascli
```
```bash
./cascli <<< "SELECT cql_version FROM system.local"
```

Fist parameter is config file name, default is clascli.ini in current directory
Example:
```ini
[cassandra]
ips=127.0.0.1
user=cass_user
pass=cass_pass
```

Second paramater is section in config (default is cassandra)

Example:
```ini
[cassandra]
ips=127.0.0.1
user=cass_user
pass=cass_pass
[dev]
ips=127.0.0.2
user=cass_user
pass=cass_pass
[prd]
ips=127.0.0.3
user=cass_user
pass=cass_pass
```

```sh
 printf "SELECT cql_version FROM system.local"|./cascli bla.ini dev
```
```bash
./cascli bla.ini dev <<< "SELECT cql_version FROM system.local"
```

## Building

Nix/NixOS version

```sh
 nix build .

 printf "SELECT cql_version FROM system.local"|./result/bin/cascli
```

LSB version (Linux Standard Base, mostly any other Linux)

```sh
 nix build .#cascli

 printf "SELECT cql_version FROM system.local"|./result/cascli/cascli
```

## Requirements

#### Build

- [Nix Package Manager](https://nixos.org/download), can be installed in any Linux

#### Runtime

- [libcassandra](https://github.com/datastax/cpp-driver) (~3 MB), downloaded to ./result/cascli.tar.gz and ./result/cascli.sh, in LSB version
- [libuv](https://github.com/libuv/libuv) (~0.2 MB), downloaded to ./result/cascli.tar.gz and ./result/cascli.sh, in LSB version
- [openssl 3](https://www.openssl.org/) (~6 MB, you must install in LSB version

## TODO:

- [Support more data types](https://github.com/yglukhov/cassandra/blob/master/cassandra/asyncwrapper.nim#L517)
- musl release
