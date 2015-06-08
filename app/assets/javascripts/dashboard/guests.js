$(document).ready(function(){
    if ($(window).width() > 750) {
        $(".guests-table-arrow").css("height", $(".guests-table").height());
    }
    else {
        $(".guests-table-arrow").css("height", "24px");
    }
    $(window).on("resize", function(){
        if ($(window).width() > 750) {
            $(".guests-table-arrow").css("height", $(".guests-table").height());
        }
        else {
            $(".guests-table-arrow").css("height", "24px");
        }
    });
    $(".guests-table-arrow i").click(function(){
        $(".guests-table").toggleClass("guests-table-minimized");
        $(".guests-table-arrow i").toggleClass("upwards");
          if ($(window).width() > 750) {
          $(".guests-table-arrow").css("height", $(".guests-table").height());
          }
          else {
              $(".guests-table-arrow").css("height", "24px");
          }
    });
});
