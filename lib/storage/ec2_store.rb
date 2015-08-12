# ec2_store.rb - class Ec2Store

class Ec2Store < JsonStore
  def initialize fname='ec2_default.json', options={}
    super fname, options
  end


  # initialize @options with sensible values: t1.micro, ami-xxxx
  def self.default
    ec2_fname = format_fname 'default'
    self.new ec2_fname, {
      key_name: 'edhowland.rwcitekllc',
    nin_count: 1,
      max_count: 1,
      instance_type: 't1.micro',
      image_id: 'ami-16c5b87e'
    }
  end



end

