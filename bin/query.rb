#!/usr/bin/env ruby
# query.rb - query AWS resources

require '../lib/application'

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
options do|opts|
  opts_on('-e', '--list-ec2', 'Enumerates all EC2 instances in this region') do
    list_ec2_instances
  end

  opts.on('-s', '--list-s3', 'Enumerates S3 objects', ) do
    list_s3_objects
  end
end

puts 'Done'
