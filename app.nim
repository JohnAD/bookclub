import jester
import strutils
import httpcore

import json

import karax / [karaxdsl, vdom]

proc registerForm(errList: seq[string]): string =
  let vnode = buildHtml(html):
    head:
      title: text "book club"
    body:
      h3: text "Register"
      text "Enter your email address to sign up."
      if errList.len > 0:
        p:
          text "Error(s) Found"
        ul:
          for msg in errList:
            li:
              bold: text msg
      form(action = "/register-form", `method` = "POST"):
        input(`type` = "text", name = "email")
        button(`type` = "submit"):
          text "Send Email Address"
  return $vnode


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
  get "/api/1.0/me/clublist":
    let clublist = parseJson("""
      {
        "clublist": [
          {"name": "Mystery Club"},
          {"name": "Iowa Clean Livin' Club"}
        ]
      }
    """)
    resp clublist
