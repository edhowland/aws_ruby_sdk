# option_decorator.rb - class OptionDecorator
class OptionDecorator < HandlerFramework
  def _end; end # need this to signal end of sublass method list

  def initialize
    @options = expand_options
  end

  attr_reader :options

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

  def expand_options
      decorations = decorators
    decorators.keys.each do |key|
      options = decorations[key]
      long = chain_case key.to_s
      long = "--#{long}"
      long += ' name' unless options[:arg].nil?
      short = options[:short] || key.to_s[0]
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

end
