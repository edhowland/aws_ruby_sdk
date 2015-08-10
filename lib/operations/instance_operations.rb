# instance_operations.rb - class InstanceOperations

# perform operationson EC2 instance
class InstanceOperations
  def initialize instance
    @instance = instance
  end

  def stop
    @instance.stop
  end

end
