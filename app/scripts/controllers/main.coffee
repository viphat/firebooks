'use strict'

###*
 # @ngdoc function
 # @name fireBooksApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the fireBooksApp
###
angular.module 'fireBooksApp'
.controller 'MainCtrl', ['$q', '$rootScope', '$scope', 'ConnectionService', 'BooksService', ($q, $rootScope, $scope, ConnectionService, BooksService) ->

  $scope.isLoading = true
  $scope.uid = undefined
  $scope.user =
    email: ""
    password: ""

  $rootScope.$on('setSubView', (event, args)->
    $scope.subView = args if $scope.subView != args
  )

  $rootScope.$on('UserLogOut', (event, args)->
    $scope.uid = undefined if $scope.uid?
  )

  promises = []

  promises.push BooksService.countOfAllBooks()
  promises.push BooksService.countOfPrintedBooks()
  promises.push BooksService.countOfDigitalBooks()
  promises.push BooksService.countOfReadBooks()
  promises.push BooksService.countOfNeedToReadAgainBooks()

  $q.all(promises).then (values) ->
    $scope.isLoading = false
    $scope.countOfAllBooks = values[0]
    $scope.totalPage = parseInt($scope.countOfAllBooks / $scope.pageSize) + 1
    $scope.countOfPrintedBooks = values[1]
    $scope.countOfDigitalBooks = values[2]
    $scope.countOfReadBooks = parseInt(values[3]) + parseInt(values[4])

  $scope.logIn = () ->
    return unless $scope.user?
    return unless $scope.user.email?
    return unless $scope.user.password?
    $scope.uid = undefined

    ConnectionService.logIn($scope.user).then (res) ->
      $scope.uid = res.uid
      $scope.$apply()
]