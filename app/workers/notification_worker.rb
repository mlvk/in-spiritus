class NotificationWorker
  include Sidekiq::Worker
  include MailUtils

  sidekiq_options :retry => false, unique: :until_executed

  def perform
    Notification
      .pending
      .select { |n| n.has_documents? }
      .each(&method(:process))
  end

  def process(n)
    send_notification n
    n.processed_at = DateTime.now
    n.save
    n.mark_processed!
  end
end
