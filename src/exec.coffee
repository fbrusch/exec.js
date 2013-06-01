exec = require("child_process").exec
fs = require "fs"
logger = require "./log"
md5 = require "MD5"
swig = require "swig"
TMP_DIR = "./tmp"
tmp = (filename) -> 
    TMP_DIR + "/" + filename

mainTemplate = swig.compile "
#include <stdio.h>\n

{{f}}

int main()
{
    printf (\"%i\",f({{args}}));
}
"

console.log mainTemplate {args:"none"}
execC = (prg, callback) ->
    filename = md5 prg
    fs.writeFile (tmp filename) + ".c", prg, {}, ->
        exec "gcc " + [(tmp filename) + ".c", "-o", (tmp filename)].join(" "),
            (error, stdout, stderr) ->
                exec (tmp filename), (error, stdout, stderr) ->
                    callback stdout

evalCf = (f, args, callback) ->
    f_args = (x.toString() for x in args).join(",")
    prg = mainTemplate {f: f, args: f_args}
    execC prg, callback

module.exports =
    execC: execC
    evalCf: evalCf
