# json_store.rb  class JsonStore

# abstract class for storing hash in a JSON file
class JsonStore
  def initialize fname, options={}
    @fname = fname
    @options = options
  end

  attr_accessor :fname, :options

  def convert_keys
  end
end
