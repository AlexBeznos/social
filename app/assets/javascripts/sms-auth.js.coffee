$id = 0
$(document).ready ->
  currentPath = ->
    return window.location.pathname.replace /login/, ''

  resend_sms = (e) ->
    e.preventDefault()

    $.ajax
      type: 'POST',
      url: "#{currentPath()}gowifi_sms/#{$id}/resend",
      error: (xhr, str) ->
        alert(JSON.parse(xhr.responseText).error)

  $('.gowifi_sms_form').submit (e) ->
    e.preventDefault()
    data = $(e.currentTarget).serialize()

    $.ajax
      type: 'POST',
      url: "#{currentPath()}gowifi_sms",
      data: data,
      success: (data) ->
        [$id, resend_link] = [data.id, $('#resend_sms')]

        $(e.currentTarget).hide()
        $('.by_sms_form').show()
        resend_link.click(resend_sms)
        resend_link.show()
      error: (xhr, str) ->
        alert(JSON.parse(xhr.responseText).error)
