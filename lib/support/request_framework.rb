# request_framework.rb - class RequestFramework

class RequestFramework
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
end
