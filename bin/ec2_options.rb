# ec2_options.rb -Ec2Options

class Ec2Options
  def initialize fname='ec2_default.json', options={}
    @fname = fname
    @options = options
  end

  def self.load fname
    options = JSON.load(File.read(fname))
    self.new fname, options
  end

  def save
    File.write(@fname, @options.to_json)
  end
end

