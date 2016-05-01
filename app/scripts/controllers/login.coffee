'use strict'
angular.module 'fireBooksApp'
.controller 'LogInCtrl', [ '$rootScope', '$scope', 'ConnectionService', 'userPayload', ($rootScope, $scope, ConnectionService, userPayload) ->

  $scope.user =
    email: ""
    password: ""

  $scope.logIn = () ->
    return unless $scope.user?
    return unless $scope.user.email?
    return unless $scope.user.password?

    ConnectionService.logIn($scope.user).then (res) ->
      userPayload.uid = res.uid
      $scope.uid = res.uid
      $scope.$emit('userLoggedIn', res.uid)

  return
]
