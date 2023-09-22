import std/asyncdispatch
import std/os
import std/parsecfg
import std/strutils
import std/terminal
import cassandra
import cassandra/bindings

iterator rows(r: Result): Row {.inline.} =
  let it = r.o.cass_iterator_from_result
  while it.cass_iterator_next == cass_true:
    let o = it.cass_iterator_get_row
    yield Row(o: o)


proc main() {.async.} =
  if stdin.isATTY:
    echo """Excpect a CQL command from stdin"""
    quit 1

  let configFile =
    if paramCount() >= 1:
      1.paramStr
    else:
      "cascli.ini"
  let configSection =
    if paramCount() >= 2:
      2.paramStr
    else:
      "cassandra"

  let cfg = configFile.loadConfig

  let cluster = newCluster()
  let session = newSession()

  # Add contact points
  cluster.setContactPoints(cfg.getSectionValue(configSection, "ips"))
  cluster.setCredentials(  cfg.getSectionValue(configSection, "user"),
                           cfg.getSectionValue(configSection, "pass"))

  # Provide the cluster object as configuration to connect the session
  discard await session.connect(cluster)
  let query     = stdin.readAll
  let statement = newStatement(query)
  let res       = await session.execute(statement)
  let cols      = cass_result_column_count(res.o).uint
  var headers   = newSeq[string]()
  var c: cstring
  var sz: csize_t
  for i in 0 ..< cols:
    discard cass_result_column_name(res.o, i, cast[cstringArray](addr c), addr sz)
    headers.add($c)

  echo headers.join(",")
  for r in res.rows():
    var line = newSeq[string]()
    for i in 0 ..< cols:
      let v = Value(o: r.o.cass_row_get_column(i.csize_t))
      case v.kind
      of CASS_VALUE_TYPE_TEXT, CASS_VALUE_TYPE_VARCHAR:
        line.add '"' & $v & '"'
      else:
        line.add($v)
    echo line.join(",")

when isMainModule:
  waitFor main()
