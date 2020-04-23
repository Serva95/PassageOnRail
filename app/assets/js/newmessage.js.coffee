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

  run = () ->
    new Newmessage()
    setTimeout( run, 30 * 1000)

  setTimeout( run, 30 * 1000) #first time call run after 30 secs

jQuery ->
  $( document ).ready( new Newmessage )
