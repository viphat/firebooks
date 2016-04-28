'use strict'

###*
 # @ngdoc function
 # @name fireBooksApp.controller: SidebarCtrl
 # @description
 # # SidebarCtrl
 # Controller of the fireBooksApp
###
angular.module 'fireBooksApp'
.controller 'SidebarCtrl', [ '$scope', '$location', 'ConnectionService', 'MainService', ($scope, $location, ConnectionService, MainService) ->

  ConnectionService.checkAuthState()

  angular.element(document).ready () ->
    $('[data-toggle=offcanvas]').click () ->
      $('.row-offcanvas').toggleClass('active')

  $scope.logOut = () ->
    ConnectionService.logOut()
    $scope.$emit('UserLogOut')

  $scope.setSubView = (item) ->
    $scope.item = item
    $scope.$emit('setSubView', item)

  console.log $location.path()
  $scope.setSubView('statistics')

  return
]
