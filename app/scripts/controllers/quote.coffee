'use strict'
angular.module 'fireBooksApp'
.controller 'QuoteCtrl', [ '$scope', 'QuotesService', ($scope, QuotesService) ->
  $scope.quote =
    content: ""
    source: ""

  $scope.create = () ->
    return if $scope.quote.content is ""
    return if $scope.quote.source is ""
    return if $scope.isPosting is true
    $scope.isPosting = true
    QuotesService.addNewQuote($scope.quote).then (res) ->
      swal("Done","Tạo một quote mới thành công!", "success")


  return
]
