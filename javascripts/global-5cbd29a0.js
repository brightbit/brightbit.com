(function() {
  $(function() {
    var animateVisible, headerAffix, replaceSVG;
    animateVisible = (function() {
      var isElementInViewport;
      isElementInViewport = function() {
        var scrollTop, viewportHeight;
        scrollTop = $(window).scrollTop();
        viewportHeight = $(window).height();
        return $('.animate').each(function() {
          var aboveBottom, belowTop, elBottom, elHeight, elTop;
          elHeight = $(this).height();
          elTop = $(this).offset().top;
          elBottom = elTop + elHeight;
          aboveBottom = scrollTop + viewportHeight > elTop + elHeight / 2;
          belowTop = scrollTop < elBottom + elHeight;
          if (aboveBottom && belowTop) {
            if (!$(this).hasClass('animated')) {
              return $(this).addClass('animated').trigger('animated');
            }
          } else {
            if ($(this).hasClass('animated')) {
              return $(this).removeClass('animated');
            }
          }
        });
      };
      $(isElementInViewport);
      return $(window).scroll(isElementInViewport);
    })();
    headerAffix = (function() {
      return $(".site-header").affix({
        offset: {
          top: $(".site-header").offset().top
        }
      });
    })();
    replaceSVG = (function() {
      if (!Modernizr.svg) {
        return $("img.svg").each(function() {
          var img, png_src;
          img = $(this);
          png_src = img.attr("src").replace(".svg", ".png");
          return img.attr("src", png_src);
        });
      }
    })();
    $('.nav-toggle').click(function() {
      var $target;
      $target = $($(this).data('target'));
      if ($target.css('display') === 'none') {
        return $target.slideDown(250);
      } else {
        return $target.slideUp(250);
      }
    });
    if (window.location.hash === "#contact") {
      return $('#contact').modal('show');
    }
  });

  $(window).on('page:change', function() {
    animateVisible();
    headerAffix();
    return replaceSVG();
  });

}).call(this);
