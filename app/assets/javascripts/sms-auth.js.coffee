$id = 0
$(document).ready ->
  currentPath = ->
    return window.location.pathname.replace /login/, ''

  sendSmsCode = (e) ->
    e.preventDefault()
    data = $(e.currentTarget).serialize()

    $.ajax
      type: 'POST',
      url: "#{currentPath()}by_sms",
      data: data,
      success: (data) ->
        window.location.replace data.url
      error: (xhr, str) ->
        alert(JSON.parse(xhr.responseText).error)

  resendSms = (e) ->
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
        [$id, resendLink] = [data.id, $('#resend_sms')]

        $(e.currentTarget).hide()
        $('.by_sms_form').show()
        $('.by_sms_form').submit(sendSmsCode)
        resendLink.click(resendSms)
        resendLink.show()
      error: (xhr, str) ->
        alert(JSON.parse(xhr.responseText).error)
