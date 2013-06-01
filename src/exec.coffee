spawn = require("child_process").spawn
fs = require "fs"
logger = require "./log"

execC = (prg, callback) ->
    fs.writeFile "prg.c", prg, {}, ->
        compile = spawn "gcc", ["prg.c"]
        compile.on "close", ->
            logger.info "compilazione finita"
            run = spawn "./a.out", []
            run.stdout.on "data", (data) ->
                callback data.toString()
            run.stdout.on "end", ->
                logger.info "eof"
            run.on "close", ->
                logger.info "esecuzione finita"

module.exports =
    execC: execC

