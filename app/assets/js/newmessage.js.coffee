class Newmessage
  constructor: ->
    @chats = $("[notification-chat='chats']")
    @setup() #if @chats.length > 0

  setup: ->
    $.ajax(
      url: "/chats.json"
      dataType: "JSON"
      method: "GET"
      success: @handleSuccess
    )

  handleSuccess: (data) =>
    $notify = '&nbsp;&nbsp;&nbsp;<i class="fas fa-circle blu" title="Nuovo messaggio in questa chat"></i>'
    if data.length > 0
      $actual = $('[notification-chat="chats"]').html($notify)
    else
      setTimeout( run, 60 * 1000)

  run = () ->
    new Newmessage()

jQuery ->
  $( document ).ready( new Newmessage )
