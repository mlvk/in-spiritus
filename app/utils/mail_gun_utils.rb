module MailGunUtils
	include PdfUtils

	def mg_client
		@mail_gun_client ||= Mailgun::Client.new(ENV['MAIL_GUN_API_KEY'])
  end

  def send_message(mb_obj)
		p "Sending email #{mb_obj}"
    mg_client.send_message ENV['MAIL_GUN_DOMAIN'], mb_obj
  end

	def email_new_purchase_order(order)
		html = ERB.new(File.open('app/views/emails/new_purchase_order.html.erb').read).result(binding)
    txt = ERB.new(File.open('app/views/emails/new_purchase_order.txt.erb').read).result(binding)
    date_fmt = order.delivery_date.strftime('%d/%m/%y')

    mb_obj = Mailgun::MessageBuilder.new
    mb_obj.from(ENV['SALES_FROM_EMAIL'], {"first"=>"Aram", "last" => "Zadikian"})
		mb_obj.add_recipient(:to, 'az@mlvegankitchen.com', {"first"=>'Aram', "last" => 'Zadikian'})
    # mb_obj.add_recipient(:to, rule.email, {"first"=>rule.first_name, "last" => rule.last_name || ""})
    mb_obj.subject("New Purchase Order - MLVK - #{order.order_number} - #{date_fmt}")
    mb_obj.body_html(html)
    mb_obj.body_text(txt)
		mb_obj.add_attachment(generate_purchase_order_pdf([order]), "Purchase Order - #{order.order_number} - #{date_fmt}.pdf")

		send_message mb_obj
	end

	def email_updated_purchase_order(order, attachment)

	end
end
