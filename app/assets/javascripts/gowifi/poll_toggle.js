function scroller(top, state){
  $('#poll-container').data('state', state);

  if(scroller.distance < $(window).height()){
    if(padding.defaultPosition === 'center' && state === "closed"){
      padding.animateCenter(".content");
    }
  }

  if(scroller.distance > $(window).height()){
    if(state === 'open' && padding.defaultPosition === 'center'){
      padding.animateTop(".content");
    };
    $('html,body').animate({ scrollTop: top }, 'slow');
  }
}

$(document).ready(function(){
  $('#poll-button').click(function(){
    $("#poll-container").toggle(500, function () {
      switch($('#poll-container').data('state')) {
        case undefined :
          scroller.distance = $("#poll-container").height() + $(".content").height();
          scroller($("#poll-button").offset().top, 'open');
          break;
        case 'open' :
         scroller.distance = 0 + $(".content").height();
          scroller($(".content").offset().top, 'closed');
          break;
        case 'closed' :
          scroller.distance = $("#poll-container").height() + $(".content").height();
          scroller($("#poll-button").offset().top, 'open');
          break;
      }
    });
  });
});
