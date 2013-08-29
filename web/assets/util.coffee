@Util =
  fullWsUrl: (path) ->
    loc = window.location
    prot = if loc.protocol == "https:" then "wss:" else "ws:"

    prot + "//" + loc.host + path

  propertyNames: (data) ->
    res = []

    for k, v of data[0]
      res.push k

    res
