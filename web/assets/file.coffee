app = angular.module('app', ['ngTable']);
app.controller 'FileCtrl', ($scope, $filter, ngTableParams) ->
  $scope.headers = []
  $scope.contents = []

  $scope.contentsTable = null

  $scope.init = () ->
    $scope.ws = new WebSocket(Util.fullWsUrl("/contents"))

    $scope.ws.onmessage = (msg) ->
      data = JSON.parse(msg.data)

      if data.length > 0
        $scope.$apply ->
          $scope.headers = Util.propertyNames(data)
          console.info $scope.headers
          $scope.contents = data
#          $scope.contentsTable =
#            new ngTableParams
#              page: 1
#              total: data.length
#              count: 10
#              sorting:
#                name: 'asc'
          console.info $scope.contents