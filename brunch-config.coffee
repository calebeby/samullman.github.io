module.exports =
  files:
    stylesheets: joinTo: 'site.css'

  paths:
    watched:
      ['source/stylesheets']

  plugins:

    stylus:
      plugins: ['jeet', 'rupture']
