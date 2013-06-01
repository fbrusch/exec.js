assert = require "assert"
execC  = require("../src/exec").execC

describe "exec", ->
    describe "execC", ->
        program = "#include <stdio.h>\nint main()\n{printf(\"ciao\");\n}"
        it "should be that " + program + " produces \"ciao\"", (done) ->
            execC program, (value) ->
                assert.equal value, "ciao"
                done()
    describe "evalCf", ->
        f = "int f(int a){return a+1}"
        it "should be that " + f + "should evaluate to 1 when passed 0", (done) ->
            evalCf f, [0], (result) ->
                assert.equal result, 1

