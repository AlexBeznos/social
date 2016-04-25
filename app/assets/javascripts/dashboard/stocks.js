$(document).ready(function () {
    $("#check_all_days").change(function () {
      $(".stocks input:checkbox").prop('checked', $(this).prop("checked"));
    });
});