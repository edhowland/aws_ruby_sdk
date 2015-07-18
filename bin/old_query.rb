#!/usr/bin/env ruby
# query.rb - query AWS resources

require '../lib/application'
require './messages'

class QueryRequestor < RequestFramework
  def list_regions description='List U. S. Regions'
    puts <<-EOP
  List of U.S. Regions:

  us-west-1
  us-west-2
  us-east-1
  EOP
  end

  def list_keys description='List Key Pairs'
    puts 'Enumerating key pairs by name'
    ec2 = ec2_resource
    ec2.key_pairs.each {|key| puts key.name }
  end

  # list virtual private clouds'
  ef list_vpcs decription='List Virtual Private Clouds'
    puts 'List of Virtual Private Clouds'
    ec2 = ec2_resource
    ec2.vpcs.each do |vpc|
      puts "vpc.id: #{vpc.id}"
    puts"\tvpc.is_default:: #{vpc.is_default.to_s}"
    puts "\tvpc.state: #{vpc.state}"
    puts
    end
  end

  ef list_groups decription='List Security Groups'
    puts 'List Security Groups'
    ec2 = ec2_resource
    ec2.security_groups.each do |group|
      puts "group.id: #{group.id}"
      puts "\tgroup.description: #{group.description}"
      puts
    end
  end

  def list_ec2 description='ListEC2 Instances' 
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

  def list_s3 description='List S3 Objects'
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

  def list_all description=List Everything''
    list_regions
    list_keys
    list_vpcs
    list_groups
    list_ec2
    list_s3
  end

end

# set any options on the command line
options do|opts|
  o opts, :list_regions, 'U. S. Regions'
  o opts, :list_keys, 'Key Pairs by name'
  o opts, :list_vpcs, 'Virtual Private Clouds'
  o opts, :list_groups, 'Security Groups'
  o opts, :list_ec2, 'EC2 Instances'
  o opts, :list_s3, 'S3 Objects'
  o opts, :list_all, 'All'
end

unless @found_options.values.reduce(false) {|i, j| i || j }

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
