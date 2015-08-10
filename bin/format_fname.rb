# format_fname.rb - method format_fname

def format_specific prefix, name
  "#{prefix}_#{name}.json"
end

def format_fname name
  File.expand_path "~/.aws/instances/#{format_specific('ec2', name)}"
end

def format_instance_fname name
  ''
end
