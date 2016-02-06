http = require 'http'
request = require 'request'

module.exports = MediawikiEdit =

  activate: (state) ->
    console.log('activate')
    server = http.createServer (req, res) ->
      if req.headers['access-control-request-headers']
        res.writeHead(200, {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': req.headers['access-control-request-headers']
          })
        return res.end('ok')

      pageName = /edit\/(.*)/.exec(req.url)[1]
      endpoint = req.headers['api-endpoint']
      token = req.headers['token']

      console.log pageName, endpoint, token

      url = endpoint + '?action=query&titles=' + pageName + '&prop=revisions&rvprop=content&format=json'
      request(url, (err, response, body) ->
        if err
          return res.end(err)

        response = JSON.parse(body)
        for i, page of response.query.pages
          content = page.revisions[0]['*']
          atom.notifications.addSuccess 'Editing ' + pageName
          atom.focus()
          atom.workspace.open().then (editor) ->
            editor.setText content
            editor.saveAs('~/atom-media-wiki-edit/' + pageName + '.mediawiki')
            editor.onDidSave () ->
              newPage = editor.getText()
              console.log 'saved'
              console.log token
              request.post(endpoint, {
                form: {
                  action: 'edit',
                  title: pageName,
                  text: newPage,
                  format: 'json',
                  token: token
                }
              }, (err, resp) ->
                if err
                  atom.notifications.addError err
                else
                  atom.notifications.addSuccess 'Edit submitted to Wiki'
              )
        res.writeHead(200, {
          'Access-Control-Allow-Origin': '*'
          })
        res.end('ok')
      )

    server.listen(5909)
  deactivate: ->

  serialize: ->

  toggle: ->
