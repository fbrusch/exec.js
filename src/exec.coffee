spawn = require("child_process").spawn
fs = require "fs"
logger = require "./log"
md5 = require "MD5"
tmp = (filename) -> 
    "./tmp/" + filename

execC = (prg, callback) ->
    filename = md5 prg
    fs.writeFile (tmp filename) + ".c", prg, {}, ->
        compile = spawn "gcc", [(tmp filename) + ".c", "-o", (tmp filename)]
        compile.on "close", ->
            logger.info "compilazione finita"
            run = spawn (tmp filename), []
            run.stdout.on "data", (data) ->
                callback data.toString()
            run.stdout.on "end", ->
                logger.info "eof"
            run.on "close", ->
                logger.info "esecuzione finita"

evalCf = (prg, args, callback) ->
    prologue = "#include <stdio.h>"
    f_args = (x.toString() for x in args).join(",")
    main = "int main(){printf(\"%i\",f(" + f_args + "));}"
    debugger
    execC ([prologue, prg, main].join "\n"), callback

module.exports =
    execC: execC
    evalCf: evalCf
