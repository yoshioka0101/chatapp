class ChatChannel < ApplicationCable::Channel
# https://xrpl.org/ja/docs/references/http-websocket-apis/public-api-methods/subscription-methods/
  def subscribed
    stream_from 'chat_channel'
  end
# https://xrpl.org/ja/docs/references/http-websocket-apis/public-api-methods/subscription-methods/unsubscribe/
  def unsubscribed
    # Any cleanup needed when channel is unsubscribedls
  end

  def receive(data)
    user = User.find_by(email: data['email'])
    
    if message = Message.create(content: data['message'], user_id: user.id)
      ActionCable.server.broadcast 'chat_channel', { message: data['message'], name: user.name, created_at: message.created_at }
    end
  end
end
