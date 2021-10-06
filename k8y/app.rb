require_relative "env"

# file = Tempfile.new('root_ca')
# file.write("hello world")
# file.rewind

# K8y::Kubeconfig::ROOT_CA_FILE = file

puts "k8y"

client = K8y::Client.from_config(K8y::Kubeconfig.from_file)
client.discover!
puts client.get_pods namespace: "some-namespace"
