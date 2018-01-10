Darkswarm.controller "FarmersMarketSubscribeCtrl", ($scope, $http) ->
  $scope.subscribe_text = 'Subscribe to our Newsletter'
  $scope.hideEmailPopup = true
  $scope.enterprise_id = null
  $scope.subscribe = (enterprise_id, loggedin) ->
    $scope.enterprise_id = enterprise_id
    if loggedin
      $http.get("/shop/subscribe/"+enterprise_id).success (data)->
        $scope.color = { 'background-color': 'green' }
        $scope.subscribe_text = 'Subscribed'
        $scope.isDisabled = true
      .error (data) ->
        alert 'Something went wrong...'
    else
      $scope.hideEmailPopup = false

  $scope.emailSubmit = () ->
    link = "/shop/subscribe/"+$scope.enterprise_id+"?email="+$scope.email
    $http.get(link).success (data)->
      $scope.color = { 'background-color': 'green' }
      $scope.subscribe_text = 'Subscribed'
      $scope.isDisabled = true
      $scope.hideEmailPopup = true
    .error (data) ->
      alert 'Something went wrong...'

  $scope.closeSubscrbe = () ->
    $scope.hideEmailPopup = true