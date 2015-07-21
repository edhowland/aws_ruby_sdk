# ec2_options.rb -Ec2Options

class Ec2Options
  def initialize
    @fname = 'ec2_default.json'
    @options = {}
  end

  attr_accessor :fname, :options
end
