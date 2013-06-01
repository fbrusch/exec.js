spawn = require("child_process").spawn
fs = require "fs"

execC = (prg, callback) ->
    fs.writeFileSync "prg.c", prg
    compile = spawn "gcc", ["prg.c"]
    compile.on "close", ->
        console.log "compilazione finita"
        run = spawn "./a.out", []
        run.stdout.on "data", (data) ->
            callback data.toString()
        run.stderr.on "data", (data) ->
            console.log data.toString()
        run.stdout.on "end", ->
            console.log "eof"
        run.on "close", ->
            console.log "esecuzione finita"

module.exports =
    execC: execC

