$(document).on("ready page:load", function() {
  function show_a_password_form() {
    var type = $("#place_enter_by_password").is(':checked');

    if(type == true){
      $(".adm_place_password").show('fast');
    } else {
      $(".adm_place_password").hide('fast');
    }
  }

  function show_backgrounds_form() {
    var type = $("#place_background_active").is(':checked');

    if(type == true){
      $(".place_backgrounds").show('fast');
    } else {
      $(".place_backgrounds").hide('fast');
    }
  }

  function show_a_message_form() {
    $('.instagram, .vkontakte, .twitter, .facebook').hide();
    var network = $("#message_network").val();

    if(network == 'vkontakte'|| network == 'facebook' || network == 'twitter') {
      $('.facebook').show();
    } else if (network == 'instagram') {
      $('.instagram').show();
    }
  }
  show_a_message_form();

  show_a_password_form();
  $('#place_enter_by_password').change(function() {
    show_a_password_form();
  }).change();

  $('#message_network').change(function() {
    show_a_message_form();
  }).change();

  $('#place_background_active').change(function() {
    show_backgrounds_form();
  }).change();
});
