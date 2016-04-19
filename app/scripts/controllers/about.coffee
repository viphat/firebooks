'use strict'

###*
 # @ngdoc function
 # @name fireBooksApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the fireBooksApp
###
angular.module 'fireBooksApp'
.controller 'AboutCtrl', [ '$scope', 'MainService', ($scope, MainService) ->
  $scope.activePage = MainService.activePage()
  return
]
