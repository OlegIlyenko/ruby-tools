@Util =
  fullWsUrl: (path) ->
    loc = window.location
    prot = if loc.protocol == "https:" then "wss:" else "ws:"

    prot + "//" + loc.host + path