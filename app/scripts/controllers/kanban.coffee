'use strict'

###*
 # @ngdoc function
 # @name fireBooksApp.controller:KanbanCtrl
 # @description
 # # KanbanCtrl
 # Controller of the fireBooksApp
###
angular.module 'fireBooksApp'
.controller 'KanbanCtrl', [ '$scope', 'MainService', ($scope, MainService) ->
  $scope.activePage = MainService.activePage()
  return
]
