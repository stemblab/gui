class $blab.Sheet
    
    constructor: (@spec) ->
        @spec.data ?= [[0]]
        @spec.colHeaders ?= ("c#{k}" for k in [0...@spec.data[0].length])
        @spec.rowHeaders ?= ("r#{k}" for k in [0...@spec.data.length])

    rowJson: ->
        x = {}
        x[rh] = @spec.data[k] for rh, k in @spec.rowHeaders
        return x

    labelRows: ->
        ([@spec.rowHeaders[m]].concat row for row, m in @spec.data)

    toLocal: ->
        eval("#{@spec.id} = app.sheet['#{@spec.id}'].spec.data")

    fromLocal: (u)->
        app.sheet[@spec.id].spec.data = u
