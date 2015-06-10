$(document).on("ready page:load", function() {
  function show_a_password_form() {
    var type = $(".enter_by_password_check").is(':checked');

    if(type == true){
      $(".enter_by_password").show('fast');
    } else {
      $(".enter_by_password").hide('fast');
    }
  }

  show_a_password_form();
  $('.enter_by_password_check').change(function() {
    show_a_password_form();
  }).change();


});
