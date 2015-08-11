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

  def reboot
    perform :reboot
  end

  def terminate
    perform :terminate
  end

  def describe
    {instance_id: @instance.id,
      public_ip: @instance.public_ip_address,
      private_ip: @instance.private_ip_address,
      state: @instance.state.name,
      type: @instance.instance_type,
      image: @instance.image.id
}
  end
end
