# format_fname.rb - method format_fname

def format_fname name
  File.expand_path "~/.aws/instances/ec2_#{name}.json"
end
