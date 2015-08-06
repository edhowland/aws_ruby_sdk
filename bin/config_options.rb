# config_options.rb - class ConfigOptions

class ConfigOptions < OptionDecorator
  def initialize options
    super
    @my_options = options
  end

  def config_fname name # {description: 'File name root for config settings', short: 'f', arg: String}
    @my_options[:config_fname] = name
end

  def display_settings # {description: 'Display currently settings'}
    @my_options[:display] = true
  end
end
