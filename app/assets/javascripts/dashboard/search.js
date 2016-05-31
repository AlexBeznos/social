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
    var value = $(this).val();
    var searchRule = new RegExp("^" + value + ".+", "i")

    $("a.place-link").parent().hide()
    $("a.place-link").each(function () {
        if (value != "" && $(this).text().search(searchRule) != -1) {
          $(this).parent().show();
        }else if(value == "") {
          $(this).parent().show();
        }
    });
    $("#places-count").text(countPlaces());
});
