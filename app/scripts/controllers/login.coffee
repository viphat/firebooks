'use strict'
angular.module 'fireBooksApp'
.controller 'LogInCtrl', [ '$rootScope', '$scope', 'ConnectionService', ($rootScope, $scope, ConnectionService) ->
  $rootScope.uid = undefined
  $rootScope.user =
    email: ""
    password: ""

  $rootScope.$on('UserLogOut', (event, args)->
    $rootScope.uid = undefined if $rootScope.uid?
  )

  $scope.logIn = () ->
    return unless $scope.user?
    return unless $scope.user.email?
    return unless $scope.user.password?
    $rootScope.uid = undefined

    ConnectionService.logIn($scope.user).then (res) ->
      $rootScope.uid = res.uid
      $scope.$apply() unless ($scope.$$phase && $scope.$root.$$phase)

  return
]
