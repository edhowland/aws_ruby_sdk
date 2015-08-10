# ec2_options.rb - class Ec2Options

class Ec2Options < JsonStore
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


  # merge two object of this class
  def merge! that
      @options = that.options.merge @options
  end

  def save
    File.write(@fname, @options.to_json)
  end
end

