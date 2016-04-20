angular.module 'fireBooksApp'
.service 'BooksService', [ '$q', '$firebaseArray', 'ConnectionService', ($q, $firebaseArray, ConnectionService) ->

  countOfDigitalBooks = () ->
    defer = $q.defer()
    ref = ConnectionService.connectFirebase("books")
    ref.orderByChild("book_type").equalTo("ebook").once("value", (snapshot) ->
      defer.resolve snapshot.numChildren()
    )
    defer.promise

  countOfPrintedBooks = () ->
    defer = $q.defer()
    ref = ConnectionService.connectFirebase("books")
    ref.orderByChild("book_type").equalTo("paper").once("value", (snapshot) ->
      defer.resolve snapshot.numChildren()
    )
    defer.promise

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
    countOfPrintedBooks: countOfPrintedBooks
    countOfDigitalBooks: countOfDigitalBooks
  }

]