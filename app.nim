import jester
import strutils
import httpcore
import htmlgen

proc registerForm(errList: seq[string]): string =
  var msgString = ""
  if errList.len > 0:
    var innerString = ""
    for msg in errList:
      innerString &= li(b(msg))
    msgString = p("Errors Found") & ul(innerString)
  result = html(
    head(title("book club")),
    body(
      "Enter your email to sign up.",
      msgString,
      form(
        action = "/register-form",
        `method` = "POST",
        input(`type` = "text", name = "email"),
        button(type = "submit", "Send Email Address")
      )
    )
  )

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
