'use strict'
angular.module 'fireBooksApp'
.controller 'SearchCtrl', [ '$scope', 'ElasticsearchService', ($scope, ElasticsearchService) ->
  $scope.obj = {}
  $scope.books = []

  # ElasticsearchService.IndexAllBooks()

  $scope.search = () ->
    return if $scope.obj.searchTerm is ""
    query = jQuery.parseJSON("{ #{$scope.obj.searchTerm} }")
    ElasticsearchService.searchBooks(query).then (res) ->
      $scope.books = res

]