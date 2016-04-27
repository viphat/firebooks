angular.module 'fireBooksApp'
.service 'BooksService', [ '$q', '$firebaseArray', 'ConnectionService', ($q, $firebaseArray, ConnectionService) ->

  countOfReadBooks = () ->
    defer = $q.defer()
    ref = ConnectionService.connectFirebase("books")
    ref.orderByChild("reading_status").equalTo("read").once("value", (snapshot) ->
      defer.resolve snapshot.numChildren()
    )
    defer.promise

  countOfNeedToReadAgainBooks = () ->
    defer = $q.defer()
    ref = ConnectionService.connectFirebase("books")
    ref.orderByChild("reading_status").equalTo("need_to_read_again").once("value", (snapshot) ->
      defer.resolve snapshot.numChildren()
    )
    defer.promise

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

  fetchBooks = (page=1, pageSize=10, oldPage=null, firstKey=null, lastKey=null) ->
    defer = $q.defer()
    ref = ConnectionService.connectFirebase()
    if page is 1
      books = $firebaseArray(ref.child("books").orderByKey().limitToFirst(pageSize))
    else
      gap = Math.abs(oldPage - page)
      NoItemFetched = (gap - 1) * pageSize
      if oldPage > page
        if gap is 1
          books = $firebaseArray(ref.child("books").orderByKey().endAt(firstKey).limitToLast(pageSize+1))
        else
          tmp = $firebaseArray(ref.child("books").orderByKey().endAt(firstKey).limitToLast(NoItemFetched+1))
          tmp.$loaded () ->
            firstKey = _.first(tmp).$id
            books = $firebaseArray(ref.child("books").orderByKey().endAt(firstKey).limitToLast(pageSize+1))
            books.$loaded ()->
              defer.resolve books
      else
        if gap is 1
          books = $firebaseArray(ref.child("books").orderByKey().startAt(lastKey).limitToFirst(pageSize+1))
        else
          tmp = $firebaseArray(ref.child("books").orderByKey().startAt(lastKey).limitToFirst(NoItemFetched+1))
          tmp.$loaded () ->
            lastKey = _.last(tmp).$id
            books = $firebaseArray(ref.child("books").orderByKey().startAt(lastKey).limitToFirst(pageSize+1))
            books.$loaded ()->
              defer.resolve books

    if books?
      books.$loaded ()->
        defer.resolve books

    defer.promise

  return {
    fetchBooks: fetchBooks
    countOfAllBooks: countOfAllBooks
    countOfPrintedBooks: countOfPrintedBooks
    countOfDigitalBooks: countOfDigitalBooks
    countOfReadBooks: countOfReadBooks
    countOfNeedToReadAgainBooks: countOfNeedToReadAgainBooks
  }

]