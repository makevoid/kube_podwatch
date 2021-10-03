require_relative "env"

client = CLIENT

pods = client.get_pods
p pods
# client.delete_pods('name', 'namespace', opts)

client.watch_pods do |notice|
  # process notice data
  puts notice
end
