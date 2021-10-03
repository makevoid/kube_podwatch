SLACK_URL_BASE = "https://hooks.slack.com/services"
SLACK_WEBHOOK_SECRETS = ENV["SLACK_WEBHOOK_SECRETS"] # channel: ...
SLACK_WEBHOOK_URL = "#{SLACK_URL_BASE}/#{SLACK_WEBHOOK_SECRETS}"

PODS_UP_THRESHOLD = 10 

# TODO: extract configs
# TODO: improve

module SlackWebhook

  def post_hook(message)
    slack_url = URI SLACK_WEBHOOK_URL
    json = { "text" => message }.to_json
    args = { "payload" => json }
    resp = Net::HTTP.post_form slack_url, args
    body = resp.body
    puts body if DEBUG
    body
  end

  def notify_slack
    puts "notifying slack..." if DEBUG
    post_hook SLACK_MESSAGE
  end

  def check_pods_up
    num = get_pods_up
    notify_slack if num <= PODS_UP_THRESHOLD
  end

end
