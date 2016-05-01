'use strict'
angular.module 'fireBooksApp'
.controller 'SidebarCtrl', [ '$rootScope', '$scope', '$route', 'ConnectionService', 'MainService', 'userPayload', ($rootScope, $scope, $route, ConnectionService, MainService, userPayload) ->

  $scope.uid = userPayload.uid || null
  ConnectionService.checkAuthState()

  $rootScope.$on('userLoggedIn', (event, args)->
    $scope.uid = args
    $scope.$apply()
  )

  angular.element(document).ready () ->
    $('[data-toggle=offcanvas]').click () ->
      $('.row-offcanvas').toggleClass('active')

  $scope.logOut = () ->
    $scope.uid = null
    userPayload.uid = null
    ConnectionService.logOut()

  checkActiveSubItem = () ->
    return $route.current.active.sub if $route.current.active?
    return 'statistics'

  $scope.activeSubItem = checkActiveSubItem()

  return
]
