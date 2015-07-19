# option_decorator.rb - class OptionDecorator
class OptionDecorator < HandlerFramework
  def _end; end # need this to signal end of sublass method list

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
      short = options[:short] || key.to_s[0]
      short = "-#{short}"

        options[:long] = long
      options[:short] = short
    end

    decorations
  end

end
