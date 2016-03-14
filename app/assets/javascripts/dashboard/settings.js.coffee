$(document).ready ->
  $('#authTabs a').click (e) ->
    e.preventDefault()

    $(this).tab('show')

    $("#newAuthLink").attr 'href', (i, a) ->
      a.replace /(step=)[a-z]+/ig, "$1#{$(e.target).attr('aria-controls')}"
