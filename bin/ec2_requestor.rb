
class Ec2Requestor < OptionDecorator
  def initialize ec2_config
    super
    @ec2 = ec2_resource
    @ec2_options = {} # {dry_run: true} # TODO: must be: = {}
    @ec2_config = ec2_config
  end

  def create_key name # {description: 'Create Key Pair', arg: String }
    check_key_name_syntax name
    keyname = key_name name
    puts "Creating Key Pair: #{keyname}"
    @ec2_options[:key_name] = keyname
    key_pair = @ec2.create_key_pair @ec2_options
    puts "Key Pair created. Fingerprint: #{key_pair.key_fingerprint}"
  end

  def delete_key name # {description: 'Delete Key Pair', arg: String }
    keyname = name 
    puts "Deleting Key Pair : #{keyname}"
    @ec2_options[:key_names] = [keyname]
    key_pairs = @ec2.key_pairs @ec2_options
    key_pair = key_pairs.first
    raise RuntimeError.new("No key found matching: #{keyname}") if key_pair.nil?
    key_pair.delete
    puts "Key Pair #{keyname} deleted."
  end

  def new_ec2 # { description: 'Create a new EC2 Instance', }
    puts 'Using options:'
    p @ec2_config.options

    instances = @ec2.create_instances @ec2_config.options
    puts "EC2 Instance ID: #{instances.first.id}"

  end

  def create_image name # {description: 'Create new AMI Image from this instance', arg: String, short: 'i'}
    print 'Name of image (3-128 chars)[Req.]: '; image_name= gets.chomp
    print 'Description of image [Opt.]: '; description = gets.chomp
    image_options = {
  #      dry_run: true,
        name: image_name
      }
    image_options[:description] = description unless description.length.zero?
    puts 'Using options:'
    p image_options
    puts "Attempting to create a new image in instance ID: #{name} with name: #{name} and description: #{description}"
    image = handle_instance @ec2, name, image_options do |instance, opts|
      instance.create_image opts
    end
    describe_image image unless image.nil?

  end

  def reboot_ec2 name # {description: 'Reboot EC2 Instance ID', arg: String, short: :nop}
    puts "Attempting to reboot instance ID: #{name}"
    response = handle_instance @ec2, name, {} do |instance, opts|
      instance.reboot opts
    end
  end

  def stop_ec2 name # {description: 'Stop EC2 Instance ID', short: 'p', arg: String}
    puts "Atteptemping to stop instance with id: #{name}"
    response = handle_instance @ec2, name do |instance, opts|
      instance.stop opts
    end


  end

  def start_ec2  name # { description: 'Starts a running EC2 Instance ID', arg: String}
    puts "Atteptemping to start instance with id: #{name}"
    response = handle_instance @ec2, name, { additional_info: "tarted by ec2_instance.rb"} do |instance, opts|
         instance.start opts
    end
  end

  def terminate_ec2 name # { description: 'Terminate EC2 Instance ID', arg: String}
    puts "Terminating instance ID: #{name}"
    response = handle_instance @ec2,name,  {} do |instance, opts|
      instance.terminate opts
    end
  end
end
