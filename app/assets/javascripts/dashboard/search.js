function countPlaces() {
  var count = 0;
  $("a.place-link").each(function () {
    if($(this).parent().css("display") != "none"){
      count++;
    }
  });
  return count;
}

$("#places-count").text(countPlaces())

$("#searchinput").on("keyup", function () {
    var value = $(this).val().replace(/\s/g, '');;
    var searchRule = new RegExp("^" + value + ".*$", "i")

    $("a.place-link").parent().hide()
    
    $("a.place-link").each(function () {
      var text = $(this).text().replace(/\s/g, '');
        if( searchRule.test(text) || value == ""){
          $(this).parent().show();
        }
    });

    $("#places-count").text(countPlaces());
});
