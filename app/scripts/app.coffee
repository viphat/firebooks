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
  'angularModalService'
]
.config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
      controllerAs: 'main'
      active: page: 'main'
    .when '/books',
      templateUrl: 'views/books.html'
      controller: 'BookCtrl'
      controllerAs: 'books'
      active: page: 'main'
    .when '/about',
      templateUrl: 'views/about.html'
      controller: 'AboutCtrl'
      controllerAs: 'about'
      active: page: 'about'
    .when '/kanban',
      templateUrl: 'views/kanban.html'
      controller: 'KanbanCtrl'
      controllerAs: 'kanban'
      active: page: 'kanban'
    .otherwise
      redirectTo: '/'