$blab.compute = ()->

    console.log "######## pre-code ########"

    for type of app.component
        for i of app.component[type]
            item = app.component[type][i]
            if item.isSource is "true"
                item.update()

    for sym of app.sheet
        app.sheet[sym].toLocal()

    console.log "######## user-code ########"

    # ??? eval app.file["user.coffee"] ???

    fn = (A, x) ->
        A.dot x
    
    b = fn(A, x)

    q = y*z[0][0]

    console.log "######## post-code ########"

    # local vars -> sheets
    for sym of app.sheet
        app.sheet[sym].fromLocal(eval(sym))

    # update sinks
    for c of app.component
        for i of app.component[c]
            item = app.component[c][i]
            item.update() # if item.isSink is "true"

class App

    # from dev.json
    #dev = $blab.resource "dev"
    #token: dev.token
    #gistId: dev.gistId
    
    constructor: ->
        
        #github = new Github
        #    token: @token
        #    auth: "oauth"

        github = new Github
            username: "anonymous"
            password:
            auth: "basic"

        @gist = github.getGist(@gistId)
        
        $("#widget-menu").menu select: (event, ui) ->
            switch ui.item[0].innerHTML
                when "Read" then app.readGist()
                when "Save" then app.saveGist()

        @readGist()

    readGist: ->
        fn = (err, gist) =>
            @file = {}
            @file[gf] = gist.files[gf].content for gf of gist.files
            @build(err,gist)

        @gist.read(fn)

    build: (err,gist) ->

        # toolbox (of component types) 

        @toolbox={}
        types = JSON.parse(@file["toolbox.json"])
        @toolbox[t.id] = $blab[t.id] for t in types

        # (data) sheets

        @sheet = {}
        specs = JSON.parse(@file["sheet.json"])
        for spec in specs
            @sheet[spec.id] = new $blab.Sheet spec

        # components

        @component = {}
        make = (type) =>
            @component[type] = {}
            for spec in JSON.parse(@file["#{type}.json"])
                spec.containerId ?= "app"
                @component[type][spec.id] = new @toolbox[type](spec, @sheet, @file)
        #make(type) for type of @toolbox
        make("Table")

    saveGist: ->

        data =
            "description": "the description for this gist"
            "files":
                "sheet2.json":
                    "content": JSON.stringify(@sheet, null, 2)

        @gist.update(data, (err, gist) -> console.log "save?", err, gist)


app = new App

