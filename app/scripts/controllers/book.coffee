'use strict'
angular.module 'fireBooksApp'
.controller 'BookCtrl', ['$q', '$location', '$timeout', '$scope', '$routeParams', '$firebaseArray', 'ConnectionService', 'BooksService', 'imgurService', 'ElasticsearchService', ($q, $location, $timeout, $scope, $routeParams, $firebaseArray, ConnectionService, BooksService, imgurService, ElasticsearchService) ->

  $scope.isUploading = false

  LoadBookBySlug = () ->
    return if $scope.isLoading is true
    $scope.isLoading = true
    return $scope.isLoading = false if !$scope.slug? || $scope.slug is ""
    ref = ConnectionService.connectFirebase("books")
    ref.orderByChild("slug").equalTo($scope.slug).on("child_added", (snapshot)->
      $scope.book = snapshot.val()
      $scope.$bookId = snapshot.key()
      ElasticsearchService.createOrUpdateIndex(snapshot)
      # ElasticsearchService.searchBooks({title: "sống"}).then (res) ->
      #   console.log res
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
    return unless $scope.book?
    return unless $scope.book.title?
    return unless $scope.book.author?
    return unless $scope.book.slug?
    return unless $scope.book.book_type?
    return unless $scope.book.reading_status?
    return unless $scope.book.current_status?
    # Get Last Book
    ref = ConnectionService.connectFirebase()
    book = $firebaseArray(ref.child("books").orderByPriority().limitToLast(1))
    book.$loaded ()->
      priority = parseInt(_.first(book).$priority) + 1
      ref = ConnectionService.connectFirebase("books")
      _.merge($scope.book, { '.priority': priority })
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
    return unless $scope.$bookId?
    ref = ConnectionService.connectFirebase("books/#{$scope.$bookId}")
    ref.remove((error)->
      if error
        console.log("Deleted Failed!")
      else
        console.log("Deleted Succesful.")
        $timeout(()->
          $location.path("/books/")
          $scope.$apply()
        , 1500 )
    )

  $scope.uploadToImgur = (event) ->
    return unless $scope.book?
    return if $scope.isUploading is true
    $scope.book.image = event.target.files[0]
    $scope.isUploading = true
    imgurService.imageUpload($scope.book.image).then (res) ->
      $scope.isUploading = false
      $scope.book.image_url = res

]