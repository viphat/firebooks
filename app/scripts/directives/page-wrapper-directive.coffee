angular.module 'fireBooksApp'
.directive 'pageWrapper', [ () ->
  restrict: "A"
  transclude: true
  scope: {}
  templateUrl: "views/page-wrapper.html"
  controller: [ '$scope', ($scope) ->

  ]
]