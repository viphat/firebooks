angular.module 'fireBooksApp'
.directive 'heartPulse', [ () ->
  restrict: "E"
  template: "
    <div class='text-xs-center'>
      <img src='https://s3-ap-southeast-1.amazonaws.com/viphat.work/books/assets/heart.svg'>
    </div>
  "
]