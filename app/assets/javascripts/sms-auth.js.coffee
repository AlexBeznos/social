$(document).ready ->
  showInFewSeconds = ->
    setTimeout "$('#resend_sms').show()", 10000

  $('#resend_sms').hide()
  showInFewSeconds()

  $('#resend_sms').click ->
    $('#resend_sms').hide()
    showInFewSeconds()

  $('#resend_sms').on 'ajax:error', (status, xhr) ->
    alert(JSON.parse(xhr.responseText).error)
