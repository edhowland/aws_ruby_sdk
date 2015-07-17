# request_framework.rb - class RequestFramework

class RequestFramework
  def handlers
    idx = self.class.instance_methods.index(:_end)
    self.class.instance_methods[0..(idx - 1)]
  end

  def long_options
    handlers.map {|e| e.to_s }.map {|e| "--#{chain_case(e)}" }
  end

  def descriptions
    descripts = {}
    handlers.each do |handler|
      descripts[handler] = self.send(handler) {|d| d}
    end
    descripts
  end
end
