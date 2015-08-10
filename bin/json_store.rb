# json_store.rb  class JsonStore

# abstract class for storing hash in a JSON file
class JsonStore
  def initialize fname, options={}
    @fname = fname
    @options = options
  end

  attr_accessor :fname, :options

  def self.convert_keys options
    symbol_options = {}
    options.each_pair.each {|key, value| symbol_options[key.to_sym] = value } 
    symbol_options
  end
end
