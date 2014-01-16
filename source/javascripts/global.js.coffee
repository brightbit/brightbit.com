$ ->
  animateVisible = do ->
    isElementInViewport = ->
      scrollTop = $(window).scrollTop()
      viewportHeight = $(window).height()
      $('.animate').each ->
        elHeight = $(this).height()
        elTop = $(this).offset().top
        elBottom = elTop + elHeight
        aboveBottom = scrollTop + viewportHeight > elTop + elHeight/2
        belowTop = scrollTop < elBottom + elHeight
        if aboveBottom and belowTop
          $(this).addClass('animated').trigger('animated') unless $(this).hasClass('animated')
        else
          $(this).removeClass('animated') if $(this).hasClass('animated')

    $(isElementInViewport)
    $(window).scroll isElementInViewport

  headerAffix = do ->
    $(".site-header").affix
      offset:
        top: $(".site-header").offset().top

  replaceSVG = do ->
    unless Modernizr.svg
      $("img.svg").each ->
        img = $(this)
        png_src = img.attr("src").replace(".svg", ".png")
        img.attr("src", png_src)

  $('.nav-toggle').click ->
    $target = $( $(this).data('target') )
    if $target.css('display') is 'none'
      $target.slideDown(250)
    else
      $target.slideUp(250)

  $('#contact').modal('show') if window.location.hash is "#contact"


$(window).on 'page:change', ->
  animatevisible()
  headerAffix()
  replaceSVG()
