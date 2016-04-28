angular.module 'fireBooksApp'
.directive 'sidebar', [ () ->
  restrict: "E"
  templateUrl: "views/sidebar.html"
  controller: "SidebarCtrl"
]