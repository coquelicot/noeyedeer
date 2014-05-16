_update_content = (data) ->
  chatbox = $('#private-chatbox')
  chatbox.empty()
  $.each data, (index, item) ->
    message = $("<div class='ui vertical segment'>")
    label = $("<div class='ui ribbon label'>")
    content = $("<div>")
    label.text(item.user)
    content.text(item.body)
    message.append(label)
    message.append(content)
    chatbox.append(message)

update_content = ->
  $.getJSON '/api/chat', _update_content

load_content = ->
  $('#loading-chat').dimmer('show')
  setTimeout ->
    $.getJSON '/api/chat', (data) ->
      _update_content(data)
      $('#loading-chat').dimmer('hide')
  , 1000

send_message = (event) ->
  $.post '/api/chat', {user: $('#msg-user').val(), body: $('#msg-msg').val()}, ->
    update_content()
    $('#msg-msg').val('')
  event.preventDefault()

$(document).ready ->

  $('#register-chat').dimmer({closable: false})
  $('#loading-chat').dimmer({closable: false})

  $('#register-chat').dimmer('show')
  $('#as-anon').click ->
    $('#register-chat').dimmer('hide')
    load_content()

  $('#msg-form').submit send_message
