class Notifications
  constructor: ->
    @notifications = $("[data-behavior='notifications']")
    if @notifications.length > 0
      @getNewNotifications()
      setInterval (=>
        @getNewNotifications()
      ), 50000
    $.ajaxSetup({
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    })

  getNewNotifications: ->
    $.ajax(
      url: "/notifications.json"
      dataType: "JSON"
      method: "GET"
      success: @handleSuccess
    )

  empty: ->
    items = "<li>
          <a class='dropdown-item' href=#>Non ci sono notifiche</a>
      </li>"
    $("[data-behavior='notification-items']").html(items)
    $("[data-behavior='unread-count']").text(0)


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

      items = $.map data, (notification) ->
        notification.template

      $("[name='notification']").remove()
      $("[data-behavior='unread-count']").text(items.length)
      $("[data-behavior='notification-items']").html(items)
      $("#mobileMenu0").after(items)
      $("[data-behavior='notifications-link']").on("click",(event) => this.handleClick(event.target.id))

jQuery ->
  new Notifications
