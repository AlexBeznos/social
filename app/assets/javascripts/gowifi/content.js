var padding = {
  containerHeight: 0,

  defaultPosition: "",

  center: function(divName){
    $(divName).css('padding-top', (this.containerHeight - $(divName).height())/2);
  },

  top: function(divName){
    $(divName).css('padding-top', 20);
  },

  animateCenter: function(divName){
    $(divName).animate({
        "padding-top" : (this.containerHeight - $(divName).height())/2
      },"slow");
  },

  animateTop: function(divName){
    $(divName).animate({
        "padding-top" : 20
      },"slow");
  }
};

function responsiveContent(){
  padding.containerHeight = $(".wrapper").height() - $(".push").height();

  if($(window).height() > $(".content").height()){
    padding.center(".content");
    padding.defaultPosition = "center";
  }else{
    padding.top(".content");
    padding.defaultPosition = "top";
  }
}

$(window).load( function() {
  responsiveContent();
});


$(window).resize( function() {
  responsiveContent();
});
