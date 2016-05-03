angular.module 'fireBooksApp'
.directive 'pagination', [ () ->
  restrict: "EA"
  scope:
    currentPage: "="
    pageSize: "="
    totalPage: "="
    pageArray: "="
    oldPage: "="
    firstKey: "="
    lastKey: "="
    childKey: "@"

  templateUrl: "views/pagination.html"
  controller: [ '$scope', '$location', ($scope, $location) ->

    $scope.goToLastPage = () ->
      return if $scope.currentPage is $scope.totalPage
      $scope.currentPage = $scope.totalPage
      $location.path("/#{$scope.childKey}/pages/#{$scope.totalPage}")

    $scope.goToFirstPage = () ->
      return if $scope.currentPage is 1
      $scope.currentPage = 1
      $location.path("/#{$scope.childKey}/pages/1")

    $scope.prevPage = () ->
      return $scope.currentPage = 1 unless $scope.currentPage?
      return if $scope.currentPage is 1
      if $scope.currentPage > 1
        $scope.currentPage -= 1
        $location.path("/#{$scope.childKey}/pages/#{$scope.currentPage}")

    $scope.nextPage = () ->
      return $scope.currentPage = 1 unless $scope.currentPage?
      return if $scope.currentPage is $scope.totalPage
      $scope.currentPage += 1
      $location.path("/#{$scope.childKey}/pages/#{$scope.currentPage}")

    $scope.setPage = (page) ->
      $scope.currentPage = page
      $location.path("/#{$scope.childKey}/pages/#{page}")

  ]
]