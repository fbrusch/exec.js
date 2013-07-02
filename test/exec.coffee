assert = require "assert"
exec = require "../src/exec"
execC = exec.execC
evalCf = exec.evalCf

describe "exec", ->
    describe "execC", ->
        program = "#include <stdio.h>\nint main()\n{printf(\"ciao\");\n}"
        it "should be that " + program + " produces \"ciao\"", (done) ->
            execC program, (retObj) ->
                assert.equal retObj.stdout, "ciao"
                done()
        notAProgram = "asdasdas"
        it "should be that " + notAProgram + "doesn't compile", (done) ->
            execC notAProgram, (retObj) ->
                assert.notEqual retObj.compileError, null
                done()

    describe "evalCf", ->
        f = "int f(int a){return a+1;}"
        it "should be that " + f + "should evaluate to 1 when passed 0", (done) ->
            evalCf f, [10], (retObj) ->
                assert.equal retObj.stdout, 11
                done()
        f2 = "int f(int a, int b){return a+b;}"
        it "should be that " + f2 + "should evaluate to 2 when passed 1 and 1", (done) ->
            evalCf f2, [1,1], (result) ->
                assert.equal result.stdout, 2
                done()
