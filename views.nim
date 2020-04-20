import moustachu
import misc
import json
import strutils

const GeneralTemplate = dedent """
  <!doctype html>
  <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
      <title>{{page_title}}</title>
    </head>
    <body>

      <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <a class="navbar-brand" href="/"><img src="/img/vbc-logo.png" width="30" height="30" alt="VBC logo" /></a>

        <ul class="nav navbar-nav ml-auto">
          <li class="nav-item active dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenu" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              <b><span class="navbar-toggler-icon"></span></b>
            </a>
            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenu">
              {{#logged_in}}
              <a class="dropdown-item" href="/logout">Logout</a>
              {{/logged_in}}
              {{^logged_in}}
              <a class="dropdown-item" href="/login-form">Login</a>
              <a class="dropdown-item" href="/register-form">Create Account</a>
              {{/logged_in}}
              <div class="dropdown-divider"></div>
              {{#logged_in}}
              <a class="dropdown-item" href="/me/admin">Admin</a>
              <a class="dropdown-item" href="/">My Clubs</a>
              {{/logged_in}}
              <a class="dropdown-item" href="/search">Search Clubs</a>
            </div>
          </li>
        </ul>

      </nav>

      <div class="msgbox-frame">
      {{#msgList}}
        <div class="alert alert-danger" role="alert">
          {{.}}
          <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
      {{/msgList}}
      </div>
      <div class="container">
        <!-- START BODY CONTENT -->
        {{{core_html}}}
        <!-- END BODY CONTENT -->
      </div>
      <nav class="navbar fixed-bottom navbar-light bg-light">
        <span class="navbar-text">Virtual Book Clubs</span>
        <a href="/about" class="navbar-right">About</a>
      </nav>

      <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
      <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
      <script src="https://unpkg.com/@popperjs/core@2"></script>
    </body>
  </html>
"""

proc showPage*(pageFile: string, content: JsonNode, msgList: seq[string]): string =
  ## `content` _must_ contain:
  ##   "page_title" (string) for the page's title
  ##   "logged_in" (bool) for whether the user is logged into an account
  content["msgList"] = newJArray()
  for msg in msgList:
    content["msgList"].add(newJString(msg))
  #
  let core = readFile("pages/$1.html".format(pageFile))
  let coreRendered = render(core, content)
  content["core_html"] = newJString(coreRendered)
  result = render(GeneralTemplate, content)

  