angular.module 'fireBooksApp'
.service 'QuotesService', ['$q', '$firebaseArray', 'ConnectionService', ($q, $firebaseArray, ConnectionService) ->

  getRandomInt = (min, max) ->
    return Math.floor(Math.random() * (max - min)) + min

  getRandomQuote = () ->
    defer = $q.defer()
    ref = ConnectionService.connectFirebase("quotes")
    ref.once("value", (snapshot) ->
      numOfQuotes = snapshot.numChildren()
      magicNumber = getRandomInt(1, numOfQuotes)
      quoteRef = ConnectionService.connectFirebase()
      quote = $firebaseArray(quoteRef.child("quotes").orderByPriority().startAt(magicNumber).limitToLast(1))
      quote.$loaded () ->
        defer.resolve _.first(quote)
    )
    defer.promise

  addNewQuote = (quote) ->
    defer = $q.defer()
    ref = ConnectionService.connectFirebase()
    quotes = $firebaseArray(ref.child("quotes").orderByPriority().limitToLast(1))
    priority = if quotes.length > 0 then parseInt(_.first(quotes).$priority) + 1 else 1
    ref = ConnectionService.connectFirebase("quotes")
    _.merge(quote, { '.priority': priority })
    ref.push(quote, (error)->
      if error?
        defer.reject
      else
        defer.resolve "done"
    )
    defer.promise

  return {
    getRandomQuote: getRandomQuote
    addNewQuote: addNewQuote
  }

]