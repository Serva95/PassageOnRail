class Notifications
  constructor: ->
    @notifications = $("[data-behavior='notifications']")
    @setup() if @notifications.length > 0
    $.ajaxSetup({
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    });



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
      data: {id: e}
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
        if (notification.notify_type == 'accepted')
          type = 'ha confermato il tuo viaggio!'
        if (notification.notify_type == 'rejected')
          type = 'non ha accettato il tuo viaggio :('
        if (notification.notify_type == 'updated')
          type = 'ha modificato il viaggio'
        if (notification.notify_type == 'deleted')
          type = 'ha annullato il viaggio'
        "<li >
           <a class='dropdown-item' href='#{notification.url}' id=#{notification.id} data-behavior=\"notifications-link\">#{notification.actor} #{type} </a>
        </li>"

      $("[data-behavior='unread-count']").text(items.length)
      $("[data-behavior='notification-items']").html(items)
      $("[data-behavior='notifications-link']").on("click",(event) => this.handleClick(event.target.id))

      #inserire visual mobile

jQuery ->
  new Notifications
