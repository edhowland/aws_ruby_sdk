# request_framework.rb - class RequestFramework

# Abstract class for command line option handlers. (See RequestFramework below)
class HandlerFramework
  def initialize
    @exec_list = []
  end

  attr_reader :exec_list

  def handlers
    idx = self.class.instance_methods.index(:_end)
    self.class.instance_methods[0..(idx - 1)]
  end

  def long_options
    longs = {}
    handlers.each {|e| longs[e] = "--#{chain_case(e)}" }
    longs
  end

  def short_options
    shorts = {}
    handlers.each {|h| shorts[h] = "-#{h.to_s[0]}" }
    shorts
  end

  def descriptions
    descripts = {}
    handlers.each do |handler|
      descripts[handler] = self.send(handler) {|d| d}
    end
    descripts
  end

  # workhorse fo this class
  def options_args
    handlers.map {|h| [h, short_options[h], long_options[h], descriptions[h] ] }
  end

  def option_list
    options_args.map {|o| "#{o[1]}, #{o[2]}\t#{o[3]}"  }.join("\n")
  end

  def set_options opts
    options_args.each {|args| opts.on(*args[1..(-1)]) { @exec_list << args[0] } }
  end

  def options_given?
    ! @exec_list.empty?
  end

  def execute!
    @exec_list.map {|h| self.send h }
  end
end

# include EndHandlers after defining your event methods
module EndHandlers
  def _end; end
end


# RequestFramework - helper for HandlerFramework. subclass this class
class RequestFramework < HandlerFramework
  include EndHandlers
end

