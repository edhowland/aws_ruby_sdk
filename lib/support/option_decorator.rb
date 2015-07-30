# option_decorator.rb - class OptionDecorator
class OptionDecorator 
  def _end; end # need this to signal end of sublass method list

  def initialize *args
    @options = expand_options
    @exec_list = []
  end

  attr_reader :options
  attr_reader :exec_list

  def handlers
    idx = self.class.instance_methods.index(:_end)
    self.class.instance_methods[0..(idx - 1)]
  end

  def eval_source source_and_line 
    line = read_line *source_and_line
    method_and_comment = line.split('#')
      eval method_and_comment[1]
  end
  def method_list
    handlers.map {|h| self.method(h) }
  end

  def decorators
    method_list.reduce({}) {|i,  m| i[m.name] = eval_source(m.source_location); i }
  end

  # expand_short :option_key, {short: 'p'} - translates option symbol to short opt, w/ overrides and arg
def expand_short key, options={}
  (options[:short] == :nop ? nil : ('-' + (options[:short] || key.to_s[0]) + (options[:arg] ? ' name' : '')))
end

  def expand_long key, options={}
    (options[:long] == :nop ? nil : (  '--' + (options[:long] || "#{chain_case(key.to_s)}") + (options[:arg] ? ' name' : '')))
  end

  def expand_options
      decorations = decorators
    decorations.keys.each do |key|
      options = decorations[key]
        options[:long] = expand_long(key, options)
      options[:short] = expand_short(key, options)
    end

    decorations
  end

  def options_args
    @options.keys.reduce([]) do |i, o|
      if @options[o][:arg].nil?
        i <<[o, @options[o][:short], @options[o][:long], @options[o][:description]]
      else
        i << [o, @options[o][:short], @options[o][:long], @options[o][:arg], @options[o][:description]]
      end
      i
    end
  end


  def on_args option_h
    args_a = []
    args_a << option_h[:short] if option_h[:short]
    args_a << option_h[:long] if option_h[:long]
    args_a <<option_h[:arg] if option_h[:arg]
    args_a << option_h[:description]    
    args_a
  end

# return opcode given key (method key), options, arg
def exec_object key, options, arg
    opcode = [key]
    opcode << arg if options[:arg]
    opcode
end

  # set options in OptionParser opts object
  def set_options opts
    @options.keys.each do |key|
        opts.on(*on_args(@options[key])) do |name|
      @exec_list << exec_object(key, @options[key], name)
      end
    end
  end

  def execute code

    if @options[code[0]][:arg].nil?
      self.send code[0]
    else
      self.send code[0],  code[1]
    end
  end

  def execute!
    @exec_list.each {|e| execute e }
  end

  def options_given?
    ! @exec_list.empty?
  end

  def option_list
    @options.keys.map {|key| "#{@options[key][:short]}, #{@options[key][:long]}\t#{@options[key][:description]}" }.join("\n")
  end
end
