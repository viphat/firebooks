'use strict'
angular.module 'fireBooksApp'
.controller 'SidebarCtrl', [ '$scope', '$route', 'ConnectionService', 'MainService', ($scope, $route, ConnectionService, MainService) ->

  ConnectionService.checkAuthState()

  angular.element(document).ready () ->
    $('[data-toggle=offcanvas]').click () ->
      $('.row-offcanvas').toggleClass('active')

  $scope.logOut = () ->
    ConnectionService.logOut()
    $scope.$emit('UserLogOut')

  checkActiveSubItem = () ->
    return $route.current.active.sub if $route.current.active?
    return 'statistics'

  $scope.activeSubItem = checkActiveSubItem()

  return
]
