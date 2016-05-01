'use strict'
angular.module 'fireBooksApp'
.controller 'QuoteCtrl', [ '$scope', 'QuotesService', 'ConnectionService', 'userPayload', ($scope, QuotesService, ConnectionService, userPayload) ->
  $scope.quote =
    content: ""
    source: ""

  $scope.create = () ->
    return swal("Bạn chưa đăng nhập!","Bạn không thể sử dụng chức năng này","error") if userPayload.uid is null
    return if $scope.quote.content is ""
    return if $scope.quote.source is ""
    return if $scope.isPosting is true
    $scope.isPosting = true
    QuotesService.addNewQuote($scope.quote).then (res) ->
      swal("Done","Tạo một quote mới thành công!", "success")


  return
]
