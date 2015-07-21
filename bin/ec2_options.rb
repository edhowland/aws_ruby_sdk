# ec2_options.rb -Ec2Options

class Ec2Options
  def initialize fname='ec2_default.json', options={}
    @fname = fname
    @options = options
  end

  attr_accessor :fname, :options

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

