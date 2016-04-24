'use strict'

###*
 # @ngdoc function
 # @name fireBooksApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the fireBooksApp
###
angular.module 'fireBooksApp'
.controller 'MainCtrl', ['$q', '$scope', 'ConnectionService', 'BooksService', 'MainService', 'imgurService', ($q, $scope, ConnectionService, BooksService, MainService, imgurService) ->

  $scope.isLoading = true
  $scope.activePage = MainService.activePage()
  $scope.firebaseUrl = ConnectionService.FirebaseUrl
  $scope.subView = 'statistics'
  $scope.uid = undefined
  $scope.firstKey = undefined
  $scope.lastKey = undefined
  $scope.oldPage = undefined
  $scope.isEditing = false
  $scope.isUploading = false
  $scope.currentPage = 1
  $scope.totalPage = 1
  $scope.pageArray = [1,2,3,4,5]
  $scope.pageSize = 10
  $scope.user =
    email: ""
    password: ""

  ConnectionService.checkAuthState()
  promises = []

  promises.push BooksService.countOfAllBooks()
  promises.push BooksService.countOfPrintedBooks()
  promises.push BooksService.countOfDigitalBooks()

  $q.all(promises).then (values) ->
    $scope.isLoading = false
    $scope.countOfAllBooks = values[0]
    $scope.totalPage = parseInt($scope.countOfAllBooks / $scope.pageSize) + 1
    $scope.countOfPrintedBooks = values[1]
    $scope.countOfDigitalBooks = values[2]

  $scope.goToLastPage = () ->
    return if $scope.currentPage is $scope.totalPage
    $scope.currentPage = $scope.totalPage

  $scope.goToFirstPage = () ->
    return if $scope.currentPage is 1
    $scope.currentPage = 1

  $scope.logOut = () ->
    ConnectionService.logOut()
    $scope.uid = undefined
    $scope.$apply()

  $scope.logIn = () ->
    return unless $scope.user?
    return unless $scope.user.email?
    return unless $scope.user.password?
    $scope.uid = undefined

    ConnectionService.logIn($scope.user).then (res) ->
      $scope.uid = res.uid
      $scope.$apply()

  angular.element(document).ready () ->
    $('[data-toggle=offcanvas]').click () ->
      $('.row-offcanvas').toggleClass('active')

  $scope.setSubView = (item) ->
    $scope.isEditing = false
    $scope.subView = item

  $scope.prevPage = () ->
    return $scope.currentPage = 1 unless $scope.currentPage?
    return if $scope.currentPage is 1
    $scope.currentPage -= 1 if $scope.currentPage > 1

  $scope.nextPage = () ->
    return $scope.currentPage = 1 unless $scope.currentPage?
    return if $scope.currentPage is $scope.totalPage
    $scope.currentPage += 1

  $scope.$watch('currentPage', (newValue, oldValue) ->
    $scope.oldPage = oldValue
    unless newValue is oldValue
      LoadBooks()
      calculatePageArray()
  )

  calculatePageArray = () ->
    return $scope.pageArray = [1,2,3,4,5] if $scope.currentPage is 1 || $scope.currentPage is 2
    return $scope.pageArray = [$scope.currentPage-4,$scope.currentPage-3,$scope.currentPage-2,$scope.currentPage-1,$scope.currentPage] if $scope.currentPage is $scope.totalPage
    return $scope.pageArray = [$scope.currentPage-3,$scope.currentPage-2,$scope.currentPage-1,$scope.currentPage,$scope.currentPage+1] if $scope.currentPage is $scope.totalPage - 1
    l = $scope.currentPage - 2
    r = $scope.currentPage + 2
    $scope.pageArray = [l, l+1, $scope.currentPage, r-1, r]

  $scope.setPage = (page) ->
    $scope.currentPage = page

  LoadBooks = () ->
    $scope.isLoading = true
    BooksService.fetchBooks($scope.currentPage, $scope.pageSize, $scope.oldPage, $scope.firstKey, $scope.lastKey).then (res) ->
      $scope.books = res
      $scope.isLoading = false
      if $scope.currentPage != 1 && $scope.oldPage?
        if $scope.oldPage < $scope.currentPage
          $scope.books = _.tail($scope.books)
        else
          $scope.books = _.take($scope.books, $scope.books.length-1)
      $scope.firstKey = _.first($scope.books).$id
      $scope.lastKey = _.last($scope.books).$id

  LoadBooks()

  $scope.selectBook = (id) ->
    $scope.$bookId = id
    ref = ConnectionService.connectFirebase("books/#{id}")
    ref.on("value", (snapshot)->
      $scope.subView = "viewBook"
      $scope.book = snapshot.val()
    )

  $scope.save = () ->
    return unless $scope.book?
    return unless $scope.$bookId?
    if $scope.isEditing is true
      ref = ConnectionService.connectFirebase("books/#{$scope.$bookId}")
      ref.update($scope.book, (error)->
        unless (error)
          console.log "Upload succeeded"
      )

  $scope.resetForm = () ->
    return $scope.isEditing = false

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