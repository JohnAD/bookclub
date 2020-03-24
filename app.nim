import jester
import strutils
import httpcore

const REGISTER_FORM = """<html>
  <head>
    <title>book club!</title>
  </head>
  <body>
    <h3>Register</h3>
    Enter your email address to sign up.
    <p>
      <b>$1</b>
    </p>
    <form action="/register-form" method="POST">
      <input type="text" name="email" />
      <button type="submit">Send Email Address</button>
    </form>
  </body>
</html>
"""

routes:
  get "/":
    resp "hello world"
  get "/register-form":
    resp REGISTER_FORM.format("")
  get "/register-form/@err":
    resp REGISTER_FORM.format(@"err")
  post "/register-form":
    if request.params["email"] == "":
      redirect "/register-form/$1".format("NeedEmailAddress")
    else:
      redirect "/hello/$1".format(request.params["email"])
  get "/hello/@email":
    resp "hello $1!".format(@"email")
  post "/":
    resp "something else"