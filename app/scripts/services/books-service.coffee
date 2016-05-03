angular.module 'fireBooksApp'
.service 'BooksService', [ '$q', '$firebaseArray', 'ConnectionService', 'MainService', ($q, $firebaseArray, ConnectionService, MainService) ->

  addSlugToBooks = () ->
    ref = ConnectionService.connectFirebase()
    books = $firebaseArray(ref.child("books").orderByKey().limitToFirst(400))
    books.$loaded ()->
      _.each(books, (book)->
        slug = MainService.slugify(book.title)
        book = _.merge(book, { slug: slug } )
        id = book.$id
        bookRef = ConnectionService.connectFirebase("books/#{id}")
        book = _.omit( book, ['$id', '$priority'] )
        bookRef.update(book, (error) ->
          return
        )
      )

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
    MainService.fetchObjects("books", page, pageSize, oldPage, firstKey, lastKey )

  return {
    addSlugToBooks: addSlugToBooks
    fetchBooks: fetchBooks
    countOfAllBooks: countOfAllBooks
    countOfPrintedBooks: countOfPrintedBooks
    countOfDigitalBooks: countOfDigitalBooks
    countOfReadBooks: countOfReadBooks
    countOfNeedToReadAgainBooks: countOfNeedToReadAgainBooks
  }

]