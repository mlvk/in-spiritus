class UpdatedCreditNote < BaseNotificationRenderer
  def build_message(notification)
    credit_note = notification.credit_note
    date_fmt = credit_note.date.strftime('%d/%m/%y')
    context = {
      credit_note: credit_note
    }

    {
      html: build_erb("updated_credit_note_notification.html", context),
      txt: build_erb("updated_credit_note_notification.txt", context),
      subject: "New updated credit note - MLVK - #{credit_note.credit_note_number} - #{date_fmt}",
      attachments: [generate_pdfs(credit_note)]
    }
  end
end
