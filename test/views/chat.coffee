load_content = ->

  $('#loading-chat').dimmer('show')

  callback = (data) ->
    chatbox = $('#private-chatbox')
    $.each data, (index, item) ->
      title = document.createElement('h3')
      title.appendChild(document.createTextNode(item.title))
      body = document.createElement('p')
      body.appendChild(document.createTextNode(item.body))
      chatbox.append(title)
      chatbox.append(body)
    $('#loading-chat').dimmer('hide')
    

  setTimeout ->
    $.getJSON '/api/chat', callback
  , 1000


$(document).ready ->

  $('#register-chat').dimmer({'closable': false});
  $('#loading-chat').dimmer({'closable': false});

  $('#register-chat').dimmer('show')
  $('#as-anon').click ->
    $('#register-chat').dimmer('hide')
    load_content()
