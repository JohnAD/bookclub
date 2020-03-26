import jester
import strutils
import httpcore

include "registerform.nimf"

proc checkEmailFormat(email: string): seq[string] =
  result = @[]
  var parts = email.split('@')
  if parts.len < 2:
    result.add "MissingAtSymbol"
  elif parts.len > 2:
    result.add "TooManyAtSymbols"
  if email.contains(" "):
    result.add "ContainsSpace"
  if email == "":
    result.add "EmailEmpty"

routes:
  get "/":
    resp "hello world"
  get "/register-form":
    resp registerForm(@[])
  get "/register-form/@err":
    let errors = @"err".split("|")
    resp registerForm(errors)
  post "/register-form":
    let errors = checkEmailFormat(request.params["email"])
    if errors.len > 0:
      redirect "/register-form/$1".format(errors.join("|"))
    else:
      redirect "/hello/$1".format(request.params["email"])
  get "/hello/@email":
    resp "hello $1!".format(@"email")
