module MailUtils
  def mg_client
		@mail_gun_client ||= Mailgun::Client.new(ENV['MAIL_GUN_API_KEY'])
  end

  def send_notification(notification)
    Rails.logger.info("[Mail]: Sending notification #{notification.id}")

    msg = notification.build_message

    mg_client.send_message(ENV['MAIL_GUN_DOMAIN'], msg) if msg.present?
  end

  def send_email(options)
    Rails.logger.info("[Mail]: Sending email")

    msg = create_message options

    mg_client.send_message(ENV['MAIL_GUN_DOMAIN'], msg) if msg.present?
  end

  def build_erb(erb, context)
    ERB.new(File.read("app/views/emails/#{erb}.erb")).result(binding)
  end

  private
  def create_message(options)
    message = Mailgun::MessageBuilder.new
    message.from(ENV['SALES_FROM_EMAIL'], {"first"=>"Aram", "last" => "Zadikian"})

    recipients = options[:recipients] || []
    recipients.each do |recipient|
      message.add_recipient(:to, recipient[:email], {first: recipient[:first_name], last: recipient[:last_name]})
    end

    message.subject(options[:subject])
    message.body_html(options[:html])
    message.body_text(options[:txt])

    attachments = options[:attachments] || []
    attachments.each do |attachment|
      message.add_attachment(attachment, "#{SecureRandom.hex(5)}.pdf")
    end

    message
  end
end
