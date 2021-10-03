require_relative "env"

puts "k8y"

client = K8y::Client.from_config(K8y::Kubeconfig.from_file)
client.discover!
puts client.get_pods namespace: "some-namespace"
