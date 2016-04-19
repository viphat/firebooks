'use strict'

###*
 # @ngdoc function
 # @name fireBooksApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the fireBooksApp
###
angular.module 'fireBooksApp'
.controller 'MainCtrl', ['$scope', 'ConnectionService', 'BooksService', 'MainService', ($scope, ConnectionService, BooksService, MainService) ->

  $scope.activePage = MainService.activePage()
  $scope.subView = 'statistics'
  $scope.uid = undefined
  $scope.user =
    email: ""
    password: ""

  ConnectionService.checkAuthState()
  BooksService.countOfAllBooks().then (value) ->
    $scope.countOfAllBooks = value

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
    $scope.subView = item

  $scope.books = BooksService.fetchBooks()

  $scope.books.$loaded () ->
    $scope.book = _.first($scope.books)
    # $scope.books.$indexFor('-KCLmiL1SSBMOJ2aVzyn')

  $scope.openBook = (item) ->
    console.log item

  # Common SQL Queries Converted for Firebase - https://www.firebase.com/blog/2013-10-01-queries-part-one.html
  # Firebase Web Guide - https://www.firebase.com/docs/web/guide/
  # AngularFire Guide - https://www.firebase.com/docs/web/libraries/angular/guide/


]