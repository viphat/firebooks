angular.module 'fireBooksApp'
.service 'ConnectionService', [ ->

  connectFirebase = (sub=null) ->
    return new Firebase("https://flickering-inferno-2708.firebaseio.com") unless sub?
    return new Firebase("https://flickering-inferno-2708.firebaseio.com/#{sub}")

  signUpCallback = (error, userData) ->
    if error
      console.log 'Error creating user:', error
    else
      console.log 'Successfully created user account with uid:', userData.uid
    return

  authHandler = (error, authData) ->
    if (error)
      console.log("Login Failed!", error)
    else
      console.log("Authenticated successfully with payload:", authData)

  authCallback = (authData) ->
    if (authData)
      console.log("User #{authData.uid} is logged in with #{authData.provider}")
    else
      console.log("User is logged out")

  checkAuthState = () ->
    ref = connectFirebase()
    ref.onAuth(authCallback)

  signUp = (user) ->
    ref = connectFirebase()
    ref.createUser(user, signUpCallback)

  logIn = (user) ->
    ref = connectFirebase()
    ref.authWithPassword({
      email: user.email
      password: user.password
    }, authHandler)

  logOut = () ->
    ref = connectFirebase()
    ref.unauth()

  return {
    connectFirebase: connectFirebase
    signUp: signUp
    checkAuthState: checkAuthState
    logIn: logIn
    logOut: logOut
  }

]