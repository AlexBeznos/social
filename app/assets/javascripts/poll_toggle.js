$(document).ready(function(){
  $('#poll-button').click(function(){
    $("#poll-container").toggle(500);
    if($('#poll-container').is(':visible')) {
      $('html,body').animate({
        scrollTop: $("#poll-container").offset().top
      }, 'slow');
    }
  });
});
