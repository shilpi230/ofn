Darkswarm.controller "EnterprisesCtrl", ($scope, $rootScope, $timeout, $location, Enterprises, Search, $document, HashNavigation, FilterSelectorsService, EnterpriseModal, enterpriseMatchesNameQueryFilter, distanceWithinKmFilter) ->
  $scope.Enterprises = Enterprises
  $scope.producers_to_filter = Enterprises.producers
  $scope.filterSelectors = FilterSelectorsService.createSelectors()
  $scope.query = Search.search()
  $scope.openModal = EnterpriseModal.open
  $scope.activeTaxons = []
  $scope.show_profiles = false
  $scope.filtersActive = false
  $scope.distanceMatchesShown = false
  $scope.filterExpression = {active: true}


  $scope.$watch "query", (query)->
    Enterprises.flagMatching query
    Search.search query
    $rootScope.$broadcast 'enterprisesChanged'
    $scope.distanceMatchesShown = false

    $timeout ->
      Enterprises.save_search(query)
      Enterprises.calculateDistance query, $scope.firstNameMatch()
      $rootScope.$broadcast 'enterprisesChanged'

  $timeout ->
    if $location.search()['show_closed']?
      $scope.showClosedShops()

  $scope.$watch "filtersActive", (value) ->
    $scope.$broadcast 'filtersToggled'

  $rootScope.$on "enterprisesChanged", ->
    $scope.filterEnterprises()
    $scope.updateVisibleMatches()


  # When filter settings change, this could change which name match is at the top, or even
  # result in no matches. This affects the reference point that the distance matches are
  # calculated from, so we need to recalculate distances.
  $scope.$watch '[activeTaxons, activeProperties, shippingTypes, show_profiles]', ->
    $timeout ->
      Enterprises.calculateDistance $scope.query, $scope.firstNameMatch()
      $rootScope.$broadcast 'enterprisesChanged'
  , true


  $rootScope.$on "$locationChangeSuccess", (newRoute, oldRoute) ->
    if HashNavigation.active "hubs"
      $document.scrollTo $("#hubs"), 100, 200


  $scope.filterEnterprises = ->
    es = Enterprises.hubs
    $scope.nameMatches = enterpriseMatchesNameQueryFilter(es, true)
    noNameMatches = enterpriseMatchesNameQueryFilter(es, false)
    $scope.distanceMatches = distanceWithinKmFilter(noNameMatches, $('body').attr('map-kms'))
    $scope.mapMatches = $scope.distanceMatchMarkers($scope.distanceMatches) if $scope.distanceMatches.length > 0
    $scope.mapMatches = $scope.distanceMatchMarkers($scope.nameMatches) if $scope.nameMatches.length > 0


  $scope.updateVisibleMatches = ->
    $scope.visibleMatches = if $scope.nameMatches.length == 0 || $scope.distanceMatchesShown
      $scope.nameMatches.concat $scope.distanceMatches
    else
      $scope.nameMatches


  $scope.showDistanceMatches = ->
    $scope.distanceMatchesShown = true
    $scope.updateVisibleMatches()


  $scope.firstNameMatch = ->
    if $scope.nameMatchesFiltered?
      $scope.nameMatchesFiltered[0]
    else
      undefined

  $scope.showClosedShops = ->
    delete $scope.filterExpression['active']
    $location.search('show_closed', '1')

  $scope.hideClosedShops = ->
    $scope.filterExpression['active'] = true
    $location.search('show_closed', null)

  $scope.searchWithUserLocation = ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition ((position) ->
        
        return $scope.getUserLocationAddress(position)
      ), ->
        alert 'Something went wrong'
        return
    else
      alert 'Browser doesn\'t support Geolocation'

  $scope.getUserLocationAddress = (position) ->
    latlng = $scope.getLatLng(position)
    geocoder = new google.maps.Geocoder
    geocoder.geocode { 'location': latlng }, (results, status) ->
      if status == 'OK'
        if results[1]
          Enterprises.save_search(results[0].formatted_address)
          $scope.pushAddressToTextBox(results[0].formatted_address)
        else
          alert 'Couldn\'t find your location'
      else
        alert 'Geocoder failed due to: ' + status
      return

  $scope.getLatLng = (position) ->
    return pos =
            lat: position.coords.latitude
            lng: position.coords.longitude

  $scope.pushAddressToTextBox = (query) ->
    $('#address_search').val query
    angular.element('#address_search').triggerHandler('click');

  $scope.userMilesChange = (e) ->
    map_kms = e.target.value * MILES_TO_KMS
    $('body').attr('map-kms', map_kms);
    $scope.filterEnterprises()
    return true

  $scope.distanceMatchMarkers = (enterprises) ->
    markers = []
    for enterprise in enterprises
      markers.push $scope.createMarkers(enterprise) if enterprise.active
    markers

  $scope.createMarkers = (enterprise) ->
    new class MapMarker
      latitude: enterprise.latitude
      longitude: enterprise.longitude
      icon: enterprise.icon
      id: enterprise.id
      reveal: =>
        $scope.openModal enterprise
