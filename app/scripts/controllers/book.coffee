'use strict'

###*
 # @ngdoc function
 # @name fireBooksApp.controller:BookCtrl
 # @description
 # # BookCtrl
 # Controller of the fireBooksApp
###
angular.module 'fireBooksApp'
.controller 'BookCtrl', ['$q', '$location', '$timeout', '$scope', '$routeParams', 'ConnectionService', 'BooksService', 'imgurService', ($q, $location, $timeout, $scope, $routeParams, ConnectionService, BooksService, imgurService) ->

  $scope.isUploading = false

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

  if $location.path() == "/books/new"
    $scope.book = {}
  else
    $scope.slug = $routeParams.slug || ""
    $scope.isEditing = false
    $scope.isLoading = false
    LoadBookBySlug()

  $scope.create = () ->
    console.log $scope.book
    return unless $scope.book?
    return unless $scope.book.title?
    return unless $scope.book.author?
    return unless $scope.book.slug?
    return unless $scope.book.book_type?
    return unless $scope.book.reading_status?
    return unless $scope.book.current_status?
    ref = ConnectionService.connectFirebase("books")
    ref.push($scope.book, (error)->
      if (error)
        console.log("Add Book Failed")
      else
        console.log("Successful")
        $timeout(()->
          $location.path("/books/#{$scope.book.slug}")
          $scope.$apply()
        , 1500 )
    )

  $scope.selectBookById = (id) ->
    $scope.$bookId = id
    ref = ConnectionService.connectFirebase("books/#{id}")
    ref.on("value", (snapshot)->
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