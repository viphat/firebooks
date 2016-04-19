angular.module 'fireBooksApp'
.service 'BooksService', [ '$q', '$firebaseArray', 'ConnectionService', ($q, $firebaseArray, ConnectionService) ->

  countOfAllBooks = () ->
    defer = $q.defer()
    ref = ConnectionService.connectFirebase("books")
    ref.once("value", (snapshot) ->
      defer.resolve snapshot.numChildren()
    )
    defer.promise

  fetchBooks = () ->
    ref = ConnectionService.connectFirebase()
    booksRef = ref.child("books").orderByChild("created_at").limitToLast(30)
    return $firebaseArray(booksRef)

  return {
    fetchBooks: fetchBooks
    countOfAllBooks: countOfAllBooks
  }

]