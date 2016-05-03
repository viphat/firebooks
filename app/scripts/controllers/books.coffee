'use strict'
angular.module 'fireBooksApp'
.controller 'BooksCtrl', ['$q', '$timeout', '$routeParams', '$scope', 'ConnectionService', 'MainService', 'BooksService', ($q,  $timeout, $routeParams, $scope, ConnectionService, MainService, BooksService ) ->

  $scope.isLoading = true
  $scope.firstKey = undefined
  $scope.lastKey = undefined
  $scope.oldPage = undefined unless $scope.oldPage?
  $scope.currentPage = parseInt($routeParams.page) || 1
  $scope.pageSize = 10
  $scope.books = []
  $scope.pageArray = []

  loadTotalPage = () ->
    BooksService.countOfAllBooks().then (res) ->
      $scope.totalPage =  parseInt( res / $scope.pageSize + 1)
      calculatePageArray()

  loadTotalPage()

  $scope.$watch('currentPage', (newValue, oldValue) ->
    $scope.oldPage = oldValue
    unless newValue is oldValue
      LoadBooks()
  )

  calculatePageArray = () ->
    $scope.pageArray = MainService.calculatePageArray($scope.currentPage, $scope.totalPage)

  LoadBooks = () ->
    $scope.isLoading = true
    BooksService.fetchBooks($scope.currentPage, $scope.pageSize, $scope.oldPage, $scope.firstKey, $scope.lastKey).then (res) ->
      books = res
      $scope.isLoading = false
      $scope.books = null
      if $scope.currentPage != 1
        if $scope.oldPage < $scope.currentPage
          $scope.books = _.tail(books)
        else
          if books.length < $scope.pageSize
            $scope.books = _.take(books, books.length)
          else
            $scope.books = _.take(books, books.length - 1)
      else
        $scope.books = books

      $timeout(()->
        $scope.firstKey = _.first($scope.books).$id if $scope.books?
        $scope.lastKey = _.last($scope.books).$id if $scope.books?
        $scope.$apply()
      , 500)


  LoadBooks()

]