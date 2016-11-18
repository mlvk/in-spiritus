class Log

  def self.info message
    message = self.format_message message
    Rails.logger.info message
  end

  def self.error message
    message = self.format_message message
    Rails.logger.error message
  end

  def self.notify_distribution_event(message)
    payload = {
      'text' => message,
      'username' => 'distribution-bot',
      'icon_emoji' => ':minibus:'
    }

    self.post_slack_message(payload, ENV["DISTRIBUTION_SLACK_CHANNEL_URL"])
  end

  def self.notify_admins(message)
    payload = {
      'text' => message,
      'username' => 'mlvk-bot'
    }

    self.post_slack_message(payload, ENV["SLACK_CHANNEL_URL"])
  end

  private
  def self.format_message message
    "#{ Time.current.strftime("%Y/%m/%d %H:%M:%S") } #{ message }"
  end

  def self.post_slack_message(message, channel = ENV["SLACK_CHANNEL_URL"])
    RestClient.post(channel, message.to_json, content_type: :json, accept: :json)
  end
end
