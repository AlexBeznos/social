$(document).on("ready page:load", function() {
  function show_a_password_form() {
    var type = $("#place_enter_by_password").is(':checked');
    console.log(type);

    if(type == true){
      $(".adm_place_password").show('fast');
    } else {
      $(".adm_place_password").hide('fast');
    }
  }

  function show_a_message_form() {
    $('.instagram, .vk, .twitter, .facebook').hide();
    var network = $("#message_network").val();

    if(network == 'vk'|| network == 'facebook' || network == 'twitter') {
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
});
