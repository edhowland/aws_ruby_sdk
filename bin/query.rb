#!/usr/bin/env ruby
# query.rb - query AWS resources

require '../lib/application'

def list_regions
  puts <<-EOP
List of U.S. Regions:

us-west-1
us-west-2
us-east-1
EOP
end

def list_key_pairs
  puts 'Enumerating key pairs by name'
  ec2 = ec2_resource
  ec2.key_pairs.each {|key| puts key.name }
end

# list virtual private clouds'
def list_vpcs
  puts 'List of Virtual Private Clouds'
  ec2 = ec2_resource
  ec2.vpcs.each do |vpc|
    puts "vpc.id: #{vpc.id}"
  puts"\tvpc.is_default:: #{vpc.is_default.to_s}"
  puts "\tvpc.state: #{vpc.state}"
  puts
  end
end

def list_security_groups
  puts 'List Security Groups'
  ec2 = ec2_resource
  ec2.security_groups.each do |group|
    puts "group.id: #{group.id}"
    puts "\tgroup.description: #{group.description}"
    puts
  end
end

def list_ec2_instances
  puts "Acquireing EC2 rsource in Region: #{region}"
  ec2 = ec2_resource

  puts 'Enumerating EC2 Instances'
  puts 'This could take some few minutes.'
  instances = ec2.instances
  instance_count = 0
  begin
    instances.each do |instance|
      puts 'Instance of EC2'
      instance_count += 1
      puts "Instance ID: #{instance.id}"
    end
  rescue => err
    puts "Enumerating EC2 instances raised error:"
    puts err.message
  end

  puts "Found #{instance_count} Instances"
end

def list_s3_objects
  puts 'Acquiring S3 Rsources'

  s3 = s3_resource

  puts 'Enumerating Buckets'
  buckets = s3.buckets
  bucket_count = 0
  begin
    buckets.each do |bucket|
      bucket_count += 1
      puts "Found bucket: #{bucket.name}"
      puts "Bucket region: #{bucket.url}"
      puts 'Enumerating objects in buckett'
     bucket.objects.each {|obj| puts obj.key }

    end
  rescue => err
    puts "Enumerating S3 Buckets raised an error:"
    puts err.message
  end

  puts "found #{bucket_count} S3 Buckets"
end

# set any options on the command line
found_options = {region: false, key: false,vpc: false, sg: false,   ec2: false, s3: false}
options do|opts|

  option opts, :dummy_option, 'Dummy option' do
    puts 'dummy'
  exit
  end

  option opts, :list_regions, 'Enumerate U.S. Regions', 'r' do
  found_options[:region] = true
    list_regions
  end
  #opts.on('--list-regions', 'List all U.S. Regions') do
    #found_options[:region] = true
    #list_regions
  #end
  opts.on('-k', '--list-keys', 'Enumerate Key Pairs') do
    found_options[:key] = true   
    list_key_pairs
  end

  opts.on('-v', '--list-vpc', 'Enumerate Virtual Private Clouds') do
    found_options[:vpc] = true
    list_vpcs
  end

  opts.on('-g', '--list-security-groups', 'Enumerate Security Groups') do
    found_options[:sg] = true
    list_security_groups
  end
  opts.on('-e', '--list-ec2', 'Enumerates all EC2 instances in this region') do
    found_options[:ec2] = true
    list_ec2_instances
  end

  opts.on('-s', '--list-s3', 'Enumerates S3 objects', ) do
    list_s3_objects
    found_options[:s3] = true
  end

  opts.on('-a', '--list-all', 'Displays all queries') do
    found_options[:a] = true # not a required option, but satisfys that some option was found
    list_regions
    list_key_pairs
    list_vpcs
    list_security_groups
    list_ec2_instances
    list_s3_objects
  end
end

unless found_options.values.reduce(false) {|i, j| i || j }
  puts <<-EOP
What do you want to query?
Available options are:

--list-regions: List U.S. Regions
-k, --list-keys: Enumerates Key Pairs by name
-v, --list-vpc: List Virtual Private Clouds
-g, --list-security-groups: List Security Groups
-e, --list-ec2: List all EC2 instances
-s, --list-s3: List all S3 objects
-a, --list-all: List everything
EOP
else
  puts 'Done'
end
