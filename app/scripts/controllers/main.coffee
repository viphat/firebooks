'use strict'

###*
 # @ngdoc function
 # @name fireBooksApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the fireBooksApp
###
angular.module 'fireBooksApp'
.controller 'MainCtrl', ['$q', '$scope', 'BooksService', ($q, $scope, BooksService) ->

  $scope.isLoading = true

  promises = []

  promises.push BooksService.countOfAllBooks()
  promises.push BooksService.countOfPrintedBooks()
  promises.push BooksService.countOfDigitalBooks()
  promises.push BooksService.countOfReadBooks()
  promises.push BooksService.countOfNeedToReadAgainBooks()

  $q.all(promises).then (values) ->
    $scope.isLoading = false
    $scope.countOfAllBooks = values[0]
    $scope.countOfPrintedBooks = values[1]
    $scope.countOfDigitalBooks = values[2]
    $scope.countOfReadBooks = parseInt(values[3]) + parseInt(values[4])

]