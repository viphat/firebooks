angular.module 'fireBooksApp'
.directive 'header', [ () ->
  restrict: "E"
  templateUrl: "views/header.html"
  controller: [ '$scope', '$route', ($scope, $route) ->

    activePage = () ->
      return $route.current.active.page if $route.current.active?
      return ''

    $scope.activePage = activePage()
  ]
]