angular.module 'fireBooksApp'
.directive 'booksTable', [ () ->
  restrict: "E"
  scope:
    books: "="
    isLoading: "="
    currentPage: "="
    pageSize: "="
  templateUrl: "views/_books.template.html"
  controller: [ '$scope', '$route', ($scope, $route) ->

  ]
]