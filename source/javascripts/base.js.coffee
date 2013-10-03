# NProgress bars for Turbolinks
$(document).on 'page:fetch', -> NProgress.start()
$(document).on 'page:change', -> NProgress.done()
$(document).on 'page:restore', -> NProgress.remove()



# SVG by default, replace with png if unsupported
supportsSVG = () -> !!document.createElementNS and !!document.createElementNS("http://www.w3.org/2000/svg", "svg").createSVGRect
fallbackSVG = () ->
  if supportsSVG()
    document.documentElement.className += " svg"
  else
    document.documentElement.className += " no-svg"
    imgs = document.getElementsByTagName("img")
    dotSVG = /.*\.svg$/
    i = 0

    while i isnt imgs.length
      imgs[i].src = imgs[i].src.slice(0, -3) + "png"  if imgs[i].src.match(dotSVG)
      ++i


onLoad = () ->
  # Stuff

onChange = () ->
  map = L.mapbox.map('map', 'joshuaogle.map-6z6bwi7l')
  fallbackSVG()



$ ->
  onLoad()
  onChange()

$(document).on 'page:change', -> onChange()
