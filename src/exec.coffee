exec = require("child_process").exec
fs = require "fs"
logger = require "./log"
md5 = require "MD5"
TMP_DIR = "./tmp"
tmp = (filename) -> 
    TMP_DIR + "/" + filename

execC = (prg, callback) ->
    filename = md5 prg
    fs.writeFile (tmp filename) + ".c", prg, {}, ->
        exec "gcc " + [(tmp filename) + ".c", "-o", (tmp filename)].join(" "),
            (error, stdout, stderr) ->
                exec (tmp filename), (error, stdout, stderr) ->
                    callback stdout

evalCf = (prg, args, callback) ->
    prologue = "#include <stdio.h>"
    f_args = (x.toString() for x in args).join(",")
    main = "int main(){printf(\"%i\",f(" + f_args + "));}"
    debugger
    execC ([prologue, prg, main].join "\n"), callback

module.exports =
    execC: execC
    evalCf: evalCf
