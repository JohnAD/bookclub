import strutils

# special thanks to:
#
# https://github.com/status-im/nim-json-serialization/blob/master/tests/utils.nim
#
# for this outstandingly useful procedure
#
proc dedent*(s: string): string =
  var s = s.strip(leading = false)
  var minIndent = 99999999999
  for l in s.splitLines:
    let indent = count(l, ' ')
    if indent == 0: continue
    if indent < minIndent: minIndent = indent
  result = s.unindent(minIndent)


proc checkEmailFormat*(email: string): seq[string] =
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

