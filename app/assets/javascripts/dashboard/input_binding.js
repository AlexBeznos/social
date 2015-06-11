$(document).on("ready page:load", function() {
  function show_a_password_form() {
    var type = $(".enter_by_password_check").is(':checked');

    if(type == true){
      $(".enter_by_password").show('fast');
    } else {
      $(".enter_by_password").hide('fast');
    }
  }

  function show_a_message_form() {
    $('.instagram, .vkontakte, .twitter, .facebook').hide();
    var network = $("#message_social_network_id option:selected").text();

    if(network == 'vkontakte'|| network == 'facebook' || network == 'twitter') {
      $('.facebook').show();
    } else if (network == 'instagram') {
      $('.instagram').show();
    }
  }
  show_a_message_form();

  show_a_password_form();
  $('.enter_by_password_check').change(function() {
    show_a_password_form();
  }).change();

  $('#message_social_network_id').change(function() {
    show_a_message_form();
  }).change();

});
