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
});
