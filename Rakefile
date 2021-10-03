desc "Run"
task :run do
  sh "bundle exec ruby app.rb"
end

desc "Run - K8Y"
task :k8y do
  sh "cd k8y && bundle exec ruby app.rb"
end


task default: :run
