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
path         = require 'path'
http         = require 'http'
https        = require 'https'
roots_webriq_sitemap = require 'webriq-roots-sitemap-v2'
readDir      = require 'readdir'
roots_markdown_to_json = require 'webriq-roots-markdown-to-json'
cleanUrls = require 'clean-urls'


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

    roots_markdown_to_json(
      jsonoutput: "data",
      folder:['page/**.md', 'posts/**.md']
    ),


    roots_webriq_sitemap (
      url: "https://sitemap.netlify.com",
      directory: ["!admin"],
      folder: "public",
      file: "**/*.html"
    ),




  ]

  stylus:
    use: [axis(), rupture(), autoprefixer()]
    sourcemap: true

  'coffee-script':
    sourcemap: true

  jade:
    pretty: true

  live_reload: true

  server:
    clean_urls: true






