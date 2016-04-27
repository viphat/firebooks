angular.module 'fireBooksApp'
.directive 'starRating', [ () ->
  restrict: "EA"
  template: '<ul class="star-rating" ng-class="{readonly: readonly}">' + '  <li ng-repeat="star in stars" class="star" ng-class="{filled: star.filled}" ng-click="toggle($index)">' + '    <i class="fa fa-star"></i>' + '  </li>' + '</ul>'
  scope:
    ratingValue: '=ngModel'
    max: '=?'
    onRatingSelect: '&?'
    readonly: '=?'
  link: (scope, element, attributes) ->
    updateStars = ->
      scope.ratingValue ||= 0
      scope.stars = []
      i = 0
      while i < scope.max
        scope.stars.push filled: i < scope.ratingValue
        i++
      return

    scope.max = 5 if scope.max is undefined

    scope.toggle = (index) ->
      if scope.readonly == undefined or scope.readonly == false
        scope.ratingValue = index + 1
        scope.onRatingSelect rating: index + 1
      return

    scope.$watch 'ratingValue', (newValue, oldValue) ->
      updateStars() if newValue
      return updateStars() if scope.stars is undefined
      return
    return
]