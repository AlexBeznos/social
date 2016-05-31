$("#searchinput").on("keyup", function () {
    var value = $(this).val();
    var searchRule = new RegExp("^" + value + ".+", "i")
    $(".place-link").parent().hide()
    $("a").each(function () {
        if (value != "" && $(this).text().search(searchRule) != -1) {
          $(this).parent().show()
        }else if(value == "") {
          $(this).parent().show()
        }
    });
});
