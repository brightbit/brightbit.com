!function(){$(function(){var t,i,n;return t=function(){var t;return t=function(){var t,i;return t=$(window).scrollTop(),i=$(window).height(),$(".animate").each(function(){var n,a,e,r,o;if(r=$(this).height(),o=$(this).offset().top,e=o+r,n=t+i>o+r/2,a=e+r>t,n&&a){if(!$(this).hasClass("animated"))return $(this).addClass("animated").trigger("animated")}else if($(this).hasClass("animated"))return $(this).removeClass("animated")})},$(t),$(window).scroll(t)}(),i=function(){return $(".site-header").affix({offset:{top:$(".site-header").offset().top}})}(),n=function(){return Modernizr.svg?void 0:$("img.svg").each(function(){var t,i;return t=$(this),i=t.attr("src").replace(".svg",".png"),t.attr("src",i)})}(),"#contact"===window.location.hash?$("#contact").modal("show"):void 0}),$(window).on("page:change",function(){return animatevisible(),headerAffix(),replaceSVG()})}.call(this);