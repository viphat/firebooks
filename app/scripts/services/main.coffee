angular.module 'fireBooksApp'
.service 'MainService', [ '$route', ($route) ->

  activePage = () ->
    return $route.current.active.page if $route.current.active?
    return '' 
  
  return {
    activePage: activePage
  }

]