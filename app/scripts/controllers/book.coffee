'use strict'

###*
 # @ngdoc function
 # @name fireBooksApp.controller:BookCtrl
 # @description
 # # BookCtrl
 # Controller of the fireBooksApp
###
angular.module 'fireBooksApp'
.controller 'BookCtrl', ['$q', '$firebaseObject', '$scope', '$routeParams', 'ConnectionService', 'BooksService', 'imgurService', ($q, $firebaseObject, $scope, $routeParams, ConnectionService, BooksService, imgurService) ->

  $scope.slug = $routeParams.slug || ""

  $scope.isEditing = false
  $scope.isUploading = false
  $scope.isLoading = false

  LoadBookBySlug = () ->
    return if $scope.isLoading is true
    $scope.isLoading = true
    return $scope.isLoading = false if !$scope.slug? || $scope.slug is ""
    ref = ConnectionService.connectFirebase("books")
    ref.orderByChild("slug").equalTo($scope.slug).on("child_added", (snapshot)->
      $scope.book = snapshot.val()
      $scope.$bookId = snapshot.key()
      $scope.$apply() unless ($scope.$$phase && $scope.$root.$$phase)
    )

  LoadBookBySlug()

  $scope.selectBookById = (id) ->
    $scope.$bookId = id
    ref = ConnectionService.connectFirebase("books/#{id}")
    ref.on("value", (snapshot)->
      $scope.subView = "viewBook"
      $scope.book = snapshot.val()
    )

  $scope.ratingSelected = () ->
    return

  $scope.save = () ->
    return unless $scope.book?
    return unless $scope.$bookId?
    if $scope.isEditing is true
      ref = ConnectionService.connectFirebase("books/#{$scope.$bookId}")
      ref.update($scope.book, (error)->
        unless (error)
          $scope.isEditing = false
          $scope.$apply() unless ($scope.$$phase && $scope.$root.$$phase)
      )

  $scope.edit = () ->
    return $scope.isEditing = true

  $scope.destroy = () ->
    return

  $scope.uploadToImgur = (event) ->
    return unless $scope.book?
    return if $scope.isUploading is true
    $scope.book.image = event.target.files[0]
    $scope.isUploading = true
    imgurService.imageUpload($scope.book.image).then (res) ->
      $scope.isUploading = false
      $scope.book.image_url = res


]