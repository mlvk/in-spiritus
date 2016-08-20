module MailUtils
  def mg_client
		@mail_gun_client ||= Mailgun::Client.new(ENV['MAIL_GUN_API_KEY'])
  end

  def send_notification(notification)
		p "Sending email #{notification}"

    msg = notification.build_message

    mg_client.send_message(ENV['MAIL_GUN_DOMAIN'], msg) if msg.present?
  end
end
