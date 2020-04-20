import jester
import strutils
import httpcore

import json

import views
import misc

let topClubs = %* [
  {"name": "club one", "club_id": "1", "member_count": "40"},
  {"name": "club 2 hooray", "club_id": "2", "member_count": "20"}
]

routes:
  get "/":
    var content = newJObject()
    content["page_title"] = newJString("Virtual Book Club")
    content["logged_in"] = newJBool(false)
    content["club_list"] = topClubs
    resp showPage("index", content, @[])
  get "/register-form":
    var content = newJObject()
    content["page_title"] = newJString("Register")
    content["logged_in"] = newJBool(false)
    resp showPage("register-form", content, @[])
  get "/register-form/@err":
    let errors = @"err".split(",")
    var content = newJObject()
    content["page_title"] = newJString("Register")
    content["logged_in"] = newJBool(false)
    resp showPage("register-form", content, errors)
  post "/register-form":
    let errors = checkEmailFormat(request.params["email"])
    if errors.len > 0:
      redirect "/register-form/$1".format(errors.join(","))
    else:
      redirect "/email-sent/$1".format(request.params["email"])
  post "/register-form/@err":
    let errors = checkEmailFormat(request.params["email"])
    if errors.len > 0:
      redirect "/register-form/$1".format(errors.join(","))
    else:
      redirect "/email-sent/$1".format(request.params["email"])
  get "/email-sent/@email":
    var content = newJObject()
    content["page_title"] = newJString("Register")
    content["logged_in"] = newJBool(false)
    content["email_address"] = newJString(@"email")
    resp showPage("email-sent", content, @[])
