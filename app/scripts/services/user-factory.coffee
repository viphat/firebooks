'use strict'
angular.module 'fireBooksApp'
.factory 'userPayload', [  ->
  user = { uid: null }
  return user
]