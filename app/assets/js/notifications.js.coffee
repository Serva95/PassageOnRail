class Notifications
  constructor: ->
    @notifications = $("[data-behavior='notifications']")
    @setup() if @notifications.length > 0


  empty: ->
    items = "<li>
          <a class='dropdown-item' href=#>Non ci sono notifiche</a>
      </li>"
    $("[data-behavior='notification-items']").html(items)
    $("[data-behavior='unread-count']").text(0)

  setup: ->
    #$("[data-behavior='notifications-link']").on "click", @handleClick
    $.ajax(
      url: "/notifications.json"
      dataType: "JSON"
      method: "GET"
      success: @handleSuccess
    )

  handleClick: (e) =>
    console.log(e)
    $.ajax(
      url: "/notifications/mark_as_read"
      dataType: "JSON"
      method: "POST"
      success: ->
        $("[data-behavior='unread-count']").text(0)
    )

  handleSuccess: (data) =>
    if data.length == 0
      @empty()
    else
      console.log(data)
      items = $.map data, (notification) ->
        if (notification.notify_type == 'reservation')
          type = 'vuole partecipare al tuo viaggio'
        "<li>
           <a class='dropdown-item' href='#' onclick='@handleClick()'>#{notification.actor} #{type} </a>
        </li>"

      $("[data-behavior='unread-count']").text(items.length)
      $("[data-behavior='notification-items']").html(items)
      console.log(items)
      #items.each(
       # $("[data-behavior='notifications-link']").on "click", @handleClick)

jQuery ->
  new Notifications
