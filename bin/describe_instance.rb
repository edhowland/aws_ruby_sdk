# describe_instance.rb - method describe_instance

def describe_instance instance
        puts "Instance ID: #{instance.id}"
    puts "\tState of the instance: #{instance.state.name}"
  puts "\tInstance image: #{instance.image.id}"
    puts "\tType: #{instance.instance_type}"
    puts "\tKey Pair: #{instance.key_pair.key_name}"
    puts "\tPrivate IP Address: #{instance.private_ip_address}"
   puts "\tPublic IP: #{instance.public_ip_address}"
    puts "\tPublic DNS: #{instance.public_dns_name}"
    puts "\tVPC ID: #{instance.vpc_id}"
  puts "\tVolumes Collection"
  instance.volumes.each do |vol|
    puts "\t-------------"
    puts "\tVolumne ID: #{vol.volume_id}"
    puts "\tVolume Type: #{vol.volume_type}"
    puts "\tVolume State: #{vol.state}"
    puts "\tVolume Size: #{vol.size}"
    puts "\tSnapshot ID: #{vol.snapshot_id}"
    puts "\t Snapshots:"
    vol.snapshots.each do |snapshot|
      puts "\t\tSnapshot ID: #{snapshot.snapshot_id}"
    puts "\t\tDescription: #{snapshot.description}"
    puts "\t\tState: #{snapshot.state}"
    puts "\t\tVolume ID: #{snapshot.volume_id}"
    puts "\t\tVolume Size: #{snapshot.volume_size}"
    end
  end
end
