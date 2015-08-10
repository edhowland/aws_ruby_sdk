# instance_operations.rb - class InstanceOperations

# perform operationson EC2 instance
class InstanceOperations
  def initialize instance
    @instance = instance
  end

  def perform operation, options={}
    @instance.send(operation, options)  
  end

  def stop
    perform :stop
  end

end
