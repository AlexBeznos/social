var bannerTimer = function() {
  counter = 15;
  text = $('#countdown').text();
  $('#countdown').html(counter + text);
  $('#countdown').css("visibility", "visible");
  interval = setInterval(function() {
    counter--;
    $('#countdown').html(counter + text);
    if (counter == 0) {
      $('#close-banner').css("visibility", "visible");
      $('#countdown').css("visibility", "hidden");
      clearInterval(interval);
    }
  }, 1000);
}

$(document).ready(function(){
    $('#close-banner').click(function () {
        $('#modal').css( "display", "none" );
        $(".modalcontent").get(0).pause();
    });

    alreadyPlayed = false;

    if ($('video[name = "media"]').length){
        if (!alreadyPlayed){
          $(".modalcontent").get(0).onplay = bannerTimer();
          alreadyPlayed = true;
        }
    } else {
      bannerTimer();
    }
});


