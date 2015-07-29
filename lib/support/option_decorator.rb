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

  def expand_options
      decorations = decorators
    decorators.keys.each do |key|
      options = decorations[key]
      long = chain_case key.to_s
      long = "--#{long}"
      long += ' name' unless options[:arg].nil?
      short = expand_short(options[:short] || key.to_s[0], options)
      short = "-#{short}"
      short += ' name' unless options[:arg].nil?

        options[:long] = long
      options[:short] = short
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

  def args_to_opts_args args
    this_args = args[0]
      this_opt = @options[this_args[0]]
      on_args = []
      on_args << this_args[1] if this_opt[:short]
 #binding.pry
      on_args << this_args[2]
      on_args << this_opt[:arg]  if this_opt[:arg]
      on_args << this_args[3]

  on_args
  end
  def set_options opts
    options_args.each do |arg|
      #opts.on *on_args

      
      if @options[arg[0]][:arg].nil?
       opts.on(*arg[1..-1]) { @exec_list << [arg[0]] }
      else
       opts.on(*arg[1..-1]) {|name| @exec_list << [arg[0], name] }
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
