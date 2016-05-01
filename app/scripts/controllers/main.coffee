'use strict'
angular.module 'fireBooksApp'
.controller 'MainCtrl', ['$q', '$scope', 'BooksService', 'QuotesService', ($q, $scope, BooksService, QuotesService) ->

  $scope.isLoading = true

  promises = []

  promises.push BooksService.countOfAllBooks()
  promises.push BooksService.countOfPrintedBooks()
  promises.push BooksService.countOfDigitalBooks()
  promises.push BooksService.countOfReadBooks()
  promises.push BooksService.countOfNeedToReadAgainBooks()
  promises.push QuotesService.getRandomQuote()

  $q.all(promises).then (values) ->
    $scope.isLoading = false
    $scope.countOfAllBooks = values[0]
    $scope.countOfPrintedBooks = values[1]
    $scope.countOfDigitalBooks = values[2]
    $scope.countOfReadBooks = parseInt(values[3]) + parseInt(values[4])
    console.log values
    $scope.quote = values[5]

]