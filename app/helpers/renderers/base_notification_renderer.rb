module Renderers
  class BaseNotificationRenderer
    include PdfUtils

    def render(notification)
      options = build_message(notification)
      create_message(notification, options)
    end

    def build_erb(erb, context)
      ERB.new(File.read("app/views/emails/#{erb}.erb")).result(binding)
    end

    def create_message(notification, options)
      notification_rule = notification.notification_rule
      message = Mailgun::MessageBuilder.new
      message.from(ENV['SALES_FROM_EMAIL'], {"first"=>"Aram", "last" => "Zadikian"})
  		message.add_recipient(:to, notification_rule.email, {first: notification_rule.first_name, last: notification_rule.last_name})

      message.subject(options[:subject])
      message.body_html(options[:html])
      message.body_text(options[:txt])

      attachments = options[:attachments] || []

      attachments.each do |attachment|
        message.add_attachment(attachment, "#{SecureRandom.hex(5)}.pdf")
      end

      return message
    end
  end
end
