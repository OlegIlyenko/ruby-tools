@FileCtrl = ($scope) ->
  $scope.contents = []

  $scope.init = () ->
    $scope.ws = new WebSocket(Util.fullWsUrl("/contents"))

    $scope.ws.onmessage = (msg) ->
      console.info msg.data