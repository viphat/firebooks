'use strict'
angular.module 'fireBooksApp'
.controller 'QuotesCtrl', [ '$scope', '$timeout', '$routeParams', 'QuotesService', 'MainService', 'ConnectionService', ($scope, $timeout, $routeParams, QuotesService, MainService, ConnectionService) ->

  $scope.isLoading = true
  $scope.firstKey = undefined
  $scope.lastKey = undefined
  $scope.oldPage = undefined unless $scope.oldPage?
  $scope.currentPage = parseInt($routeParams.page) || 1
  $scope.pageSize = 12
  $scope.quotes = []
  $scope.pageArray = []

  loadTotalPage = () ->
    QuotesService.getNumberOfQuotes().then (res) ->
      $scope.totalPage =  parseInt( res / $scope.pageSize + 1)
      calculatePageArray()

  loadTotalPage()

  $scope.$watch('currentPage', (newValue, oldValue) ->
    $scope.oldPage = oldValue
    unless newValue is oldValue
      LoadQuotes()
  )

  calculatePageArray = () ->
    $scope.pageArray = MainService.calculatePageArray($scope.currentPage, $scope.totalPage)

  LoadQuotes = () ->
    $scope.isLoading = true
    QuotesService.fetchQuotes($scope.currentPage, $scope.pageSize, $scope.oldPage, $scope.firstKey, $scope.lastKey).then (res) ->
      quotes = res
      $scope.isLoading = false
      $scope.quotes = null
      if $scope.currentPage != 1
        if $scope.oldPage < $scope.currentPage
          $scope.quotes = _.tail(quotes)
        else
          if quotes.length < $scope.pageSize
            $scope.quotes = _.take(quotes, quotes.length)
          else
            $scope.quotes = _.take(quotes, quotes.length - 1)
      else
        $scope.quotes = quotes

      $timeout(()->
        $scope.firstKey = _.first($scope.quotes).$id if $scope.quotes?
        $scope.lastKey = _.last($scope.quotes).$id if $scope.quotes?
        assignCardBackground()
        $scope.$apply()
      , 500)

  assignCardBackground = () ->
    return if $scope.quotes.length == 0
    _.each($scope.quotes, (item)->
      cardBg = _.sample(["card-primary", "card-success", "card-info", "card-danger", "card-warning"])
      _.merge(item,{
        cardBg: cardBg
      })
    )


  LoadQuotes()

  return
]
