'use strict'
###*
 # @ngdoc overview
 # @name fireBooksApp
 # @description
 # # fireBooksApp
 #
 # Main module of the application.
###
angular
.module 'fireBooksApp', [
  'ngAnimate',
  'ngCookies',
  'ngMessages',
  'ngResource',
  'ngRoute',
  'ngSanitize',
  'firebase',
  'ngImgur',
  'hc.marked',
  'angularModalService',
  'elasticsearch'
]
.service 'esClient', [ 'esFactory', (esFactory) ->
  return esFactory({
    host: 'http://search.viphat.work:9200/',
    log: 'trace'
  })
]
.config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
      active:
        page: 'main'
        sub: 'statistics'
    .when '/login',
      templateUrl: 'views/login.html'
      controller: 'LogInCtrl'
      active:
        page: 'main'
        sub: 'logIn'
    .when '/books',
      templateUrl: 'views/books.html'
      controller: 'BooksCtrl'
      active:
        page: 'main'
        sub: 'books'
    .when '/books/pages/:page',
      templateUrl: 'views/books.html'
      controller: 'BooksCtrl'
      active:
        page: 'main'
        sub: 'books'
    .when '/books/new',
      templateUrl: 'views/new_book.html'
      controller: 'BookCtrl'
      active:
        page: 'main'
        sub: 'new book'
    .when '/books/:slug',
      templateUrl: 'views/book.html'
      controller: 'BookCtrl'
      active:
        page: 'main'
        sub: 'book'
    .when '/about',
      templateUrl: 'views/about.html'
      controller: 'AboutCtrl'
      active: page: 'about'
    .when '/kanban',
      templateUrl: 'views/kanban.html'
      controller: 'KanbanCtrl'
      active: page: 'kanban'
    .otherwise
      redirectTo: '/'