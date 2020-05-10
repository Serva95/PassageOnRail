  class NotificationsController < ApplicationController
    def index
      @notifications = Notification.where(user: current_user).unread.select {|x| deleted_target?(x)}
    end

    # POST
    def mark_as_read
      @notifications = Notification.where(user: current_user, id: params[:id]).unread
      @notifications.update_all(read_at: Time.zone.now)
      render json: {success: true}
    end

    def clean
      notifications.delete_all
      redirect_to notifications_path
    end

    private

    def notifications
      raise 'You need reqiure user login for /notifications page.' unless current_user
      Notification.where(user_id: current_user.id)
    end

    def deleted_target? (obj)
      obj.target != nil && obj.second_target != nil
    end
  end