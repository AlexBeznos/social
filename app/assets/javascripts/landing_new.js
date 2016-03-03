
//= require jquery
//= require bootstrap
//= require jbox.min
//= require swiper.jquery.min

(function(d, w, s) {
var widgetId = '21334', gcw = d.createElement(s); gcw.type = 'text/javascript'; gcw.async = true;
gcw.src = '//my.binotel.ua/getcall/widgets/'+ widgetId +'.js';
var sn = d.getElementsByTagName(s)[0]; sn.parentNode.insertBefore(gcw, sn);
})(document, window, 'script');

$(document).ready(function() {
  var swiper = new Swiper('.swiper-container', {
    nextButton: '.swiper-button-next',
    prevButton: '.swiper-button-prev',
    pagination: '.swiper-pagination',
    paginationClickable: true,
    slidesPerView: 5,
    spaceBetween: 50,
    breakpoints: {
      1024: {
          slidesPerView: 4,
          spaceBetween: 40
      },
      768: {
          slidesPerView: 3,
          spaceBetween: 30
      },
      640: {
          slidesPerView: 2,
          spaceBetween: 20
      },
      320: {
          slidesPerView: 1,
          spaceBetween: 10
      }
    }
  });

  $('.flag-buttons img').click(function() {
    var index = $('.flag-buttons img').index(this);
    var description = $('.swiper-container .slider_description').eq(index);
    description.slideToggle();

    $('.swiper-container .slider_description').not(description).each(function(i, e) {
      $(e).slideUp();
    });
  });


  $(window).scroll(function () {
    if ($(this).scrollTop() > 50) {
        $('#back-to-top').fadeIn();
    } else {
        $('#back-to-top').fadeOut();
    }
  });
  // scroll body to 0px on click
  $('#back-to-top').click(function () {
    $('#back-to-top').tooltip('hide');
    $('body,html').animate({
        scrollTop: 0
    }, 800);
    return false;
  });

  $('#back-to-top').tooltip('show');

  var modal = function(message) {
    return new jBox('Modal', {
      content: message
    });
  }

  $('.feedback').submit(function(e){
    e.preventDefault()

    var name = $(this).find('input[name=name]').val();
    var tel = $(this).find('input[name=tel]').val();
    var email = $(this).find('input[name=email]').val();

    if (name == '' || tel == '' || email == '') {
      modal('Одно из полей незаполненно!').open();
      return false;
    } else {
      $.post("/feedback", {
        name: name,
        tel: tel,
        email: email
      }).success(function() {
        modal('Ваша заявка была успешно отправлена!').open();
      }).fail(function() {
        modal('Что то пошле не так. Попробуйте позже!').open();
      });
    }
  });
});
