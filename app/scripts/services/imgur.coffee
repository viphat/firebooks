angular.module 'fireBooksApp'
.service 'imgurService', ['$q', 'imgur', ( $q, imgur ) ->
  imageUpload: (file) ->
    $q (resolve, reject) ->
      imgur.setAPIKey('Client-ID 1c2773cd677b6df')

      if(file && file.type.match(/image.*/))
        imgur.upload(file).then \
          (response) ->
            resolve response.link
          , (error) ->
            reject(error)

]
.directive 'onFileChanged',[ () ->
  restrict: 'A',
  link: (scope, element, attrs) ->
    onChangeHandler = scope.$eval(attrs.onFileChanged)
    element.bind('change', onChangeHandler)
]