# ec2_options.rb -Ec2Options

class Ec2Options
  def initialize fname='ec2_default.json'
    @fname = fname
    @options = {}
  end

  def self.load fname
    self.new fname
  end

  def save
    File.write(@fname, @options.to_json)
  end
end

