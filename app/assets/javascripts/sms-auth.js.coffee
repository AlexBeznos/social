$(document).ready ->
  $('#resend_sms').on 'ajax:error', (status, xhr) ->
    alert(JSON.parse(xhr.responseText).error)