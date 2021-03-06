angular.module 'fireBooksApp'
.service 'ElasticsearchService', ['$q', 'esClient', '$firebaseArray', 'ConnectionService', ($q, esClient, $firebaseArray,  ConnectionService) ->

  IndexAllBooks = () ->
    ref = ConnectionService.connectFirebase()
    books = $firebaseArray(ref.child("books").orderByKey().limitToFirst(400))
    books.$loaded ()->
      _.each(books, (book)->
        id = book.$id
        bookRef = ConnectionService.connectFirebase("books/#{id}")
        bookRef.on("value", (snapshot) ->
          createOrUpdateIndex(snapshot)
        )
      )

  deleteFromIndexes = (id) ->
    defer = $q.defer()
    esClient.delete({index: "firebase", type: "books", id: id}, (error, resp)->
      if error?
        defer.reject(error)
      else
        defer.resolve(resp)
    )
    defer.promise

  createOrUpdateIndex = (snap) ->
    defer = $q.defer()
    esClient.index({index: "firebase", type: "books", id: snap.key(), body: snap.val() }, (error, resp) ->
      if error?
        defer.reject(error)
      else
        defer.resolve(resp)
    )
    defer.promise

  searchBooks = (query) ->
    defer = $q.defer()
    esClient.search({
      index: "firebase"
      type: "books"
      body: {
        query: {
          match: query
        }
      }
    }).then (resp) ->
      if resp.hits.hits? && resp.hits.hits.length > 0
        books = []
        _.each(resp.hits.hits, (item) ->
          book = item._source
          _.merge(book, { ".id": item._id })
          books.push book
        )
        defer.resolve books
      else
        defer.reject
    defer.promise

  testElasticsearchConnection = () ->
    esClient.cluster.state({
      metric: [
        'cluster_name',
        'nodes',
        'master_node',
        'version'
      ]
    }).then (resp) ->
      console.log resp

  return {
    createOrUpdateIndex: createOrUpdateIndex
    searchBooks: searchBooks
    IndexAllBooks: IndexAllBooks
    deleteFromIndexes: deleteFromIndexes
  }

]