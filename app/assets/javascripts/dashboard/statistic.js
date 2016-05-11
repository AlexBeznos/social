$(document).ready(function(){
  $("#from, #to").datepicker({
    dateFormat: "yy-mm-dd"
  });
});

$(document).ready(function(){
    if ($(window).width() > 750) {
        $(".statistics-table-arrow").css("height", $(".statistics-table").height());
    }
    else {
        $(".statistics-table-arrow").css("height", "24px");
    }

    $(window).on("resize", function(){
        if ($(window).width() > 750) {
            $(".statistics-table-arrow").css("height", $(".statistics-table").height());
        }
        else {
            $(".statistics-table-arrow").css("height", "24px");
        }
    });

    $(".statistics-table-arrow i").click(function(){
        $(".statistics-table").toggleClass("statistics-table-minimized");
        $(".statistics-table-arrow i").toggleClass("upwards");

        if ($(window).width() > 750) {
          $(".statistics-table-arrow").css("height", $(".statistics-table").height());
        }
        else {
          $(".statistics-table-arrow").css("height", "24px");
        }
    });

    slickCalendar();
});

function slickCalendar() {
  $(".calendar-inner").slick({
      slidesToShow: 8,
      slidesToScroll: 3,
      prevArrow: $(".aleft"),
      nextArrow: $(".aright"),
      infinite: false,
      swipe: false,
      responsive: [
          {
              breakpoint: 1024,
              settings: {
                  slidesToShow: 6
              }
          },
          {
              breakpoint: 400,
              settings: {
                  slidesToShow: 4
              }
          }
      ]
  });
}

function getUrlParameter(sParam) {
  var sPageURL = window.location.search.substring(1);
  var sURLVariables = sPageURL.split('&');
  for (var i = 0; i < sURLVariables.length; i++) {
    var sParameterName = sURLVariables[i].split('=');
    if (sParameterName[0] == sParam) {
        return sParameterName[1];
    }
  }
}

function getDaysInMonth(month, year) {
    return new Date(year, month, 0).getDate();
}

function setDaysToCalendar(number_of_days, today, year) {
  var days = '',
      i = 0;

  for( i; i < number_of_days; i++ ) {
    days += '<div class="day ' + ((i + 1) == today ? 'active' : '') + '"><h2><a href="#" class="dayNumber">' + (i + 1) + '</a></h2><a href="#"></a></div>'
  }

  $('.calendar-inner').slick('unslick');
  $('.calendar-inner').empty();
  $('.calendar-inner').append(days);
  slickCalendar();

  if(today != -1 ) {
    $('.calendar-inner').slick('slickGoTo', today - 1, true);
  }

  $('.calendar-inner a').on('click', function(e) {
    e.preventDefault();

    var dayNumber = $(this.closest('.day')).find('h2').text();
    var monthNumber = parseInt($('#month option:selected').val()) + 1;

    console.log(monthNumber);
    window.location = window.location.pathname + "?date=" + dayNumber + '-' + monthNumber + '-' + year ;
  });
}

$(document).ready(function() {
  var date = getUrlParameter('date');

  if (date == undefined) {
    date = new Date();
  } else {
    a = date.split('-');
    date = new Date(a[2], a[1] - 1, a[0]);
  }


  $($('#month option')[date.getMonth()]).attr('selected', true);
  setDaysToCalendar(getDaysInMonth(date.getMonth() + 1, date.getFullYear()), date.getDate(), date.getFullYear());

  $('#month').change(function() {
    var newMonth = $('#month option:selected').val();

    if(newMonth == date.getMonth()) {
      setDaysToCalendar(getDaysInMonth(date.getMonth() + 1, date.getFullYear()), date.getDate(), date.getFullYear());
    } else {
      setDaysToCalendar(getDaysInMonth(newMonth + 1, date.getFullYear()), - 1, date.getFullYear());
    }
  });
});
