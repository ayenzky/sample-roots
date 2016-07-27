fs           = require 'fs'
axis         = require 'axis'
rupture      = require 'rupture'
autoprefixer = require 'autoprefixer-stylus'
js_pipeline  = require 'js-pipeline'
css_pipeline = require 'css-pipeline'
records      = require 'roots-records'
collections  = require 'roots-collections'
excerpt      = require 'html-excerpt'
moment       = require 'moment'
readdirp     = require 'readdirp'
path         = require 'path'
http         = require 'http'
https        = require 'https'




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
    collections(folder: 'page', layout: 'post'),
    js_pipeline(files: 'assets/js/*.coffee'),
    css_pipeline(files: 'assets/css/*.styl'),
  ]

  stylus:
    use: [axis(), rupture(), autoprefixer()]
    sourcemap: true

  'coffee-script':
    sourcemap: true

  jade:
    pretty: true


  after:->

    options = {
      hostname: 'sitemap.netlify.com',
      protocol: 'https:',
      port:443,
      method: 'GET'
    }

    result = ""

    stream = readdirp({root:path.join(__dirname), fileFilter:['**/*.html'], directoryFilter: ['!node_modules', '!admin']})
    stream.on 'data', (entry)->

      url_path = entry.path
      str = url_path.replace(/\\/g, "/")
      file = str.substr(6);


      result += "<url><loc>" + options.protocol + "//" + options.hostname + file + "</loc></url>" + "\n";

      fs.writeFile 'public/sitemap.xml', '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'+result+'</urlset>', (err) ->
        if err then console.log err
        console.log(result);
