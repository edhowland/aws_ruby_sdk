# config_file.rb - class ConfigFile

class ConfigFile < OptionDecorator
  def initialize options
    super
    @my_options = options
  end

  def config_fname name # {description: 'File name root for config settings', short: 'f', arg: String}
    @my_options[:config_fname] = name
end

  def instance_name name  # {description: 'Set the name of the instance', arg: String, short: 'N'}
    @my_options[:instance_name] = name
  end
end
