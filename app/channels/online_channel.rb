class OnlineChannel < Turbo::StreamsChannel
  def subscribed
    current_user&.update!(status: "online")
    super
  end

  def unsubscribed
    current_user&.update!(status: "offline")
    super
  end
end