'use strict'

###*
 # @ngdoc function
 # @name fireBooksApp.controller:BooksCtrl
 # @description
 # # BooksCtrl
 # Controller of the fireBooksApp
###
angular.module 'fireBooksApp'
.controller 'BooksCtrl', ['$q', '$routeParams', '$location', '$scope', 'ConnectionService', 'BooksService', 'esClient', ($q,  $routeParams, $location, $scope, ConnectionService, BooksService, esClient) ->

  TestElasticConnection = () ->
    esClient.cluster.state({
      metric: [
        'cluster_name',
        'nodes',
        'master_node',
        'version'
      ]
    }).then (resp) ->
      console.log resp

  $scope.isLoading = true
  $scope.firstKey = undefined
  $scope.lastKey = undefined
  $scope.oldPage = undefined
  $scope.currentPage = parseInt($routeParams.page) || 1
  $scope.pageSize = 10
  loadTotalPage = () ->
    BooksService.countOfAllBooks().then (res) ->
      $scope.totalPage =  parseInt( res / $scope.pageSize + 1)
      calculatePageArray()
  loadTotalPage()
  $scope.pageArray = [1,2,3,4,5]

  $scope.goToLastPage = () ->
    return if $scope.currentPage is $scope.totalPage
    $scope.currentPage = $scope.totalPage
    $location.path("/books/pages/#{$scope.totalPage}")

  $scope.goToFirstPage = () ->
    return if $scope.currentPage is 1
    $scope.currentPage = 1
    $location.path("/books/pages/1")

  $scope.prevPage = () ->
    return $scope.currentPage = 1 unless $scope.currentPage?
    return if $scope.currentPage is 1
    if $scope.currentPage > 1
      $scope.currentPage -= 1
      $location.path("/books/pages/#{$scope.currentPage}")

  $scope.nextPage = () ->
    return $scope.currentPage = 1 unless $scope.currentPage?
    return if $scope.currentPage is $scope.totalPage
    $scope.currentPage += 1
    $location.path("/books/pages/#{$scope.currentPage}")

  $scope.$watch('currentPage', (newValue, oldValue) ->
    $scope.oldPage = oldValue
    unless newValue is oldValue
      LoadBooks()
  )

  calculatePageArray = () ->
    return $scope.pageArray = [1,2,3,4,5] if $scope.currentPage is 1 || $scope.currentPage is 2
    console.log $scope.totalPage
    return $scope.pageArray = [$scope.currentPage-4,$scope.currentPage-3,$scope.currentPage-2,$scope.currentPage-1,$scope.currentPage] if $scope.currentPage is $scope.totalPage
    return $scope.pageArray = [$scope.currentPage-3,$scope.currentPage-2,$scope.currentPage-1,$scope.currentPage,$scope.currentPage+1] if $scope.currentPage is $scope.totalPage - 1
    l = $scope.currentPage - 2
    r = $scope.currentPage + 2
    $scope.pageArray = [l, l+1, $scope.currentPage, r-1, r]

  $scope.setPage = (page) ->
    $scope.currentPage = page
    $location.path("/books/pages/#{page}")

  LoadBooks = () ->
    $scope.isLoading = true
    BooksService.fetchBooks($scope.currentPage, $scope.pageSize, $scope.oldPage, $scope.firstKey, $scope.lastKey).then (res) ->
      $scope.books = res
      $scope.isLoading = false
      if $scope.currentPage != 1 && $scope.oldPage?
        if $scope.oldPage < $scope.currentPage
          $scope.books = _.tail($scope.books)
        else
          if $scope.books.length < $scope.pageSize
            $scope.books = _.take($scope.books, $scope.books.length)
          else
            $scope.books = _.take($scope.books, $scope.books.length - 1)
      $scope.firstKey = _.first($scope.books).$id
      $scope.lastKey = _.last($scope.books).$id

  LoadBooks()

]