#!/usr/bin/env ruby
# query.rb - query AWS resources

require '../lib/application'

def list_key_pairs
  puts 'Enumerating key pairs by name'
end

def list_ec2_instances
  puts "Acquireing EC2 rsource in Region: #{ENV['AWS_REGION']}"
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
found_options = {key: false, ec2: false, s3: false}
options do|opts|
  opts.on('-k', '--list-keys', 'Enumerate Key Pairs') do
    found_options[:key] = true   
    list_key_pairs
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
    list_ec2_instances
    list_s3_objects
  end
end

unless found_options.values.reduce(false) {|i, j| i || j }
  puts <<-EOP
What do you want to query?
Available options are:
-e, --list-ec2: List all EC2 instances
-s, --list-s3: List all S3 objects
-a, --list-all: List everything
EOP
else
  puts 'Done'
end
