angular.module 'fireBooksApp'
.service 'MainService', [ () ->

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
    slugify: slugify
  }

]