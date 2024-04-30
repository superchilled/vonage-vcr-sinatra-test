# app.rb

require "sinatra"
require "tilt/erubis"
require "vonage"
require "dotenv/load"

get "/" do
  erb :index
end

post "/" do
  to_number = params[:number]
  message_text = params[:message]

  begin
    client = Vonage::Client.new(
      application_id: ENV["VCR_API_APPLICATION_ID"],
      private_key: ENV["VCR_PRIVATE_KEY"],
      api_host: 'messages-sandbox.nexmo.com'
    )
    message = client.messaging.whatsapp(type: 'text', message: message_text)
    response = client.messaging.send(to: to_number, from: ENV["VONAGE_NUMBER"], **message)
    p response

    @status_message = { class: "flash-success", text: "Message sent successfully" }
  rescue Vonage::Error => e
    @status_message = {class: "flash-error", text: "Sorry, there was a problem sending the message. Please try again."}
  end

  erb :index
end