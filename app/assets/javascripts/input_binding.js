$(document).on("ready page:load", function() {
  function show_a_form() {
    var type = $("#place_enter_by_password").is(':checked');
    console.log(type);

    if(type == true){
      $(".adm_place_password").show('fast');
    } else {
      $(".adm_place_password").hide('fast');
    }
  }

  show_a_form();
  $('#place_enter_by_password').change(function() {
    show_a_form();
  }).change();


});
