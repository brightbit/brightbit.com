# NProgress bars for Turbolinks
$(document).on 'page:fetch', -> NProgress.start()
$(document).on 'page:change', -> NProgress.done()
$(document).on 'page:restore', -> NProgress.remove()

onLoad = () ->
  # Stuff

onChange = () ->
  map = L.mapbox.map('map', 'joshuaogle.map-6z6bwi7l')



$ ->
  onLoad()
  onChange()

$(document).on 'page:change', -> onChange()
