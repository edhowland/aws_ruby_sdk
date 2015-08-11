# instance_operations.rb - class InstanceOperations

# perform operationson EC2 instance
class InstanceOperations
  def initialize instance
    @instance = instance
  end

  def perform operation, options={}
    begin
      @instance.send(operation, options)  
    rescue => err
    puts err.message
    end
  end

  def stop
    perform :stop
  end

  def start
    perform :start
  end
end
