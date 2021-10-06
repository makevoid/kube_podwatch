require_relative "env"

client = CLIENT

pods = client.get_pods
# p pods  # debug

# # you can do stuff like these if needed to update / delete pods:
# client.delete_pods('name', 'namespace', opts)

puts "WATCH PODS:"
# standard watch pod events subscripiton
client.watch_pods do |notice|
  resource = notice.object
  resource = resource.metadata
  labels = resource.labels
  created_at = Time.parse(resource.creationTimestamp).strftime "%H:%M"
  app_name_label = labels[:app]

  # state = resource.state
  # puts "State: #{state.inspect}"

  labels_string = "App: #{app_name_label.inspect}"

  # process notice data
  puts "---"
  puts "A: #{notice.type}" # action type
  puts "Pod: #{resource.name} - Namespace: #{resource.namespace} - Created At: #{created_at} - Labels: { #{labels_string} }"

  # TODO: notify_slack_webhook depending on rules (e.g. all services are up)
  # notify_slack_webhook
end
