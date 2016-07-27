axis         = require 'axis'
rupture      = require 'rupture'
autoprefixer = require 'autoprefixer-stylus'
js_pipeline  = require 'js-pipeline'
css_pipeline = require 'css-pipeline'
records      = require 'roots-records'
collections  = require 'roots-collections'
excerpt      = require 'html-excerpt'
moment       = require 'moment'
glob         = require 'glob'
readdirp     = require 'readdirp'
path         = require 'path'




monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]

module.exports =
  ignores: ['readme.md', '**/layout.*', '**/_*', '.gitignore', 'ship.*conf']

  locals:
    postExcerpt: (html, length, ellipsis) ->
      excerpt.text(html, length || 100, ellipsis || '...')
    dateFormat: (date, format) ->
      moment(date).format(format)


  extensions: [
    records(
      characters: { file: "data/characters.json" }
      site: { file: "data/site.json" }
    ),
    collections(folder: 'posts', layout: 'post'),
    js_pipeline(files: 'assets/js/*.coffee'),
    css_pipeline(files: 'assets/css/*.styl')
  ]

  stylus:
    use: [axis(), rupture(), autoprefixer()]
    sourcemap: true

  'coffee-script':
    sourcemap: true

  jade:
    pretty: true


  after:->
    glob '**/*.html', ignore: ['node_modules/**', 'README.*'], stat:true, silent:true, strict:true, (er, files)->
      console.log(files);

    result = ""

    stream = readdirp({root:path.join(__dirname), fileFilter:'**/*.html', directoryFilter: '!node_modules'})
    stream.on 'data', (entry)->
      str  = entry.path
      file = str.substr(6);
      console.log(file);

      result += ""
      result += "<url><loc>" + file + "</loc></url>" + "\n";

      console.log(result);
