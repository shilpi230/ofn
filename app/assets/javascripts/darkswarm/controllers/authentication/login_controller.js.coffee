Darkswarm.controller "LoginCtrl", ($scope, $http, $window, AuthenticationService, Redirections, Loading) ->
  $scope.path = "/login"
  $scope.producer_path = '/admin/products/bulk_edit'

  $scope.submit = ->
    Loading.message = t 'logging_in'
    $http.post("/user/spree_user/sign_in", {spree_user: $scope.spree_user}).success (data)->
      if data.is_producer == true
        $window.location.href = $window.location.origin + $scope.producer_path
      else if Redirections.after_login
        $window.location.href = $window.location.origin + Redirections.after_login
      else
        $window.location.href = $window.location.origin + $window.location.pathname  # Strips out hash fragments
    .error (data) ->
      Loading.clear()
      $scope.errors = data.message
