# handle_instance.rb - method handle_instance

def handle_instance ec2, id, options={}, &blk
  response = nil
  begin
    instance = ec2.instance id
    puts "Found instance ID: #{id}"
    response = yield instance, options
    puts 'EC2 operation Successful'
  rescue => err
    puts err.message
  end

  response
end
