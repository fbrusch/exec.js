exec = require("child_process").exec
fs = require "fs"
logger = require "./log"
md5 = require "MD5"
swig = require "swig"
TMP_DIR = process.env.TMP_DIR || "./tmp"
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

# ok, ora dobbiamo gestire:
# errori di compilazione
#
execC = (prg, callback) ->
    filename = md5 prg
    fs.writeFile (tmp filename) + ".c", prg, {}, (err) ->
        if (err isnt null) then console.log ("couldn't write file " + tmp(filename))
        else
            exec "gcc " + [(tmp filename) + ".c", "-o", (tmp filename)].join(" "),
                (compileError, compileStdout, compileStderr) ->
                    exec (tmp filename), (error, stdout, stderr) ->
                        callback (
                            stdout: stdout
                            stderr: stderr
                            error: error
                            compileStdout: compileStdout
                            compileStderr: compileStderr
                            compileError: compileError
                        )

evalCf = (f, args, callback) ->
    f_args = (x.toString() for x in args).join(",")
    prg = mainTemplate {f: f, args: f_args}
    execC prg, callback

module.exports =
    execC: execC
    evalCf: evalCf
