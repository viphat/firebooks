angular.module 'fireBooksApp'
.service 'MainService', ['$q', '$firebaseArray', 'ConnectionService', ($q, $firebaseArray, ConnectionService) ->

  calculatePageArray = (currentPage, totalPage) ->
    if totalPage <= 5
      i = 1
      arr = []
      while i <= totalPage
        arr.push i
        i = i + 1
      return arr
    return [1,2,3,4,5] if currentPage is 1 || currentPage is 2
    return [currentPage-4, currentPage-3,  currentPage-2, currentPage-1, currentPage] if currentPage is totalPage
    return [currentPage-3, currentPage-2, currentPage-1, currentPage, currentPage+1] if currentPage is totalPage - 1
    l = currentPage - 2
    r = currentPage + 2
    return [l, l+1, currentPage, r-1, r]

  fetchObjects = (child_key, page, pageSize, oldPage, firstKey, lastKey) ->
    defer = $q.defer()
    ref = ConnectionService.connectFirebase()
    if page is 1
      objects = $firebaseArray(ref.child(child_key).orderByKey().limitToFirst(pageSize))
    else
      gap = Math.abs(oldPage - page)
      NoItemFetched = (gap - 1) * pageSize
      if oldPage > page
        if gap is 1
          objects = $firebaseArray(ref.child(child_key).orderByKey().endAt(firstKey).limitToLast(pageSize+1))
        else
          tmp = $firebaseArray(ref.child(child_key).orderByKey().endAt(firstKey).limitToLast(NoItemFetched+1))
          tmp.$loaded () ->
            firstKey = _.first(tmp).$id
            objects = $firebaseArray(ref.child(child_key).orderByKey().endAt(firstKey).limitToLast(pageSize+1))
            objects.$loaded ()->
              defer.resolve objects
      else
        if gap is 1
          objects = $firebaseArray(ref.child(child_key).orderByKey().startAt(lastKey).limitToFirst(pageSize+1))
        else
          if lastKey is null
            tmp = $firebaseArray(ref.child(child_key).orderByKey().limitToFirst(NoItemFetched+1))
          else
            tmp = $firebaseArray(ref.child(child_key).orderByKey().startAt(lastKey).limitToFirst(NoItemFetched+1))
          tmp.$loaded () ->
            lastKey = _.last(tmp).$id
            objects = $firebaseArray(ref.child(child_key).orderByKey().startAt(lastKey).limitToFirst(pageSize+1))
            objects.$loaded ()->
              defer.resolve objects

    if objects?
      objects.$loaded ()->
        defer.resolve objects

    defer.promise

  slugify = (text) ->
    text = text.toString().toLowerCase()
      .replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ|U|Ú|Ù|Ụ|Ủ|Ũ|Ư|Ứ|Ừ|Ự|Ử|Ữ/g,"u")
      .replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ|A|Á|À|Ạ|Ả|Ã|Â|Ấ|Ầ|Ậ|Ẫ|Ẩ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ/g,"a")
      .replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ|E|È|É|Ẹ|Ẻ|Ẽ|Ê|Ế|Ề|Ể|Ễ|Ệ/g,"e")
      .replace(/ì|í|ị|ỉ|ĩ|I|Í|Ì|Ị|Ỉ|Ĩ/g,"i")
      .replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ|O|Ó|Ò|Ọ|Ỏ|Õ|Ô|Ố|Ồ|Ộ|Ổ|Ỗ|Ơ|Ớ|Ờ|Ợ|Ở|Ỡ/g,"o")
      .replace(/ỳ|ý|ỵ|ỷ|ỹ|Y|Ỳ|Ý|Ỵ|Ỷ|Ỹ/g,"y")
      .replace(/đ|Đ/g,"d")
      .replace(/!|@|%|\^|\*|\(|\)|\+|\=|\<|\>|\?|\/|,|\.|\:|\;|\'| |\"|\&|\#|\[|\]|~|$|_/g,"-")
      .trim().split(" ").join("-").replace(/\-\-+/g, '-')
    text = text.slice(0,-1) if text.endsWith("-")
    return text

  return {
    calculatePageArray: calculatePageArray
    slugify: slugify
    fetchObjects: fetchObjects
  }

]