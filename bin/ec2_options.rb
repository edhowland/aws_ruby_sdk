# ec2_options.rb - class Ec2Options

class Ec2Options
  def initialize fname='ec2_default.json', options={}
    @fname = fname
    @options = options
  end

  attr_accessor :fname, :options

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

  def self.load fname
    options = JSON.load(File.read(fname))
    # convert string keys to symbols
    symbol_options = {}
    options.each_pair.each {|key, value| symbol_options[key.to_sym] = value } 
    self.new fname, symbol_options
  end

  def save
    File.write(@fname, @options.to_json)
  end
end

#{"key_name":"edhowland.rwcitekllc","min_count":1,"max_count":1,"instance_type":"t1.micro","image_id":"ami-16c5b87e"}
