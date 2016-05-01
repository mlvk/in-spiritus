module MailGunUtils
	def mg_client
		@mail_gun_client ||= Mailgun::Client.new(ENV['MAIL_GUN_API_KEY'])
  end

  def send_message(mb_obj)
    mg_client.send_message ENV['MAIL_GUN_DOMAIN'], mb_obj
  end
end
