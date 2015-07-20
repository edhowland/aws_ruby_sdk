# key_pair_name.rb - method key_pair_name

# construct key pair name for ec2 from user name, identifier, region
def key_pair_name user, identifier
  "#{user}.#{identifier}.#{region}"
end

def key_name name
  key_pair_name *name.split('.')
end

