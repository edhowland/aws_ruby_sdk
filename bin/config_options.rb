# config_options.rb - class ConfigOptions

class ConfigOptions < ConfigFile # OptionDecorator
  def initialize options
    super options
  end


  def display_settings # {description: 'Display currently settings'}
    @my_options[:display] = true
  end

  def init_settings # {description: 'Set initial defaults', short: :nop}
    @my_options[:init] = true
  end
end
