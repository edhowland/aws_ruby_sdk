# host.rb - method display host_key

def host_key
  ENV['AWS_ACCESS_KEY_ID']
end

def display_host
  "Currently using Host Key: #{host_key}"
end
