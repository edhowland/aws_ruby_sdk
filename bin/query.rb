#!/usr/bin/env ruby
# query.rb - Query AWS Resources

require_relative  '../lib/application'
require './messages'
require './requestor'


def describe_instance instance
        puts "Instance ID: #{instance.id}"
  puts "\tInstance image: #{instance.image.id}"
    puts "\tType: #{instance.instance_type}"
    puts "\tKey Pair: #{instance.key_pair.key_name}"
    puts "\tPrivate IP Address: #{instance.private_ip_address}"
   puts "\tPublic IP: #{instance.public_ip_address}"
    puts "\tVPC ID: #{instance.vpc_id}"
    puts "\tPublic DNS: #{instance.public_dns_name}"
    puts "\tState of the instance: #{instance.state.name}"
    #puts "\tState Reason: #{instance.state_reason.message}"
end


# All methods names matching option long names go here.
# E.g --list-groups : -> def list_groups
class QueryRequestor < OptionDecorator
  def initialize
    super     # mandatory call super class initializer
    @ec2 = ec2_resource
  end



  def list_regions # {description: 'List U. S. Regions', short: 'r'}
    puts <<-EOP
Valid U. S. Region handles:

us-east-1
us-west-1
us-west-2
EOP
  end


  def list_keys # {description: 'List Key Pairs', short: 'k'}
    puts 'Enumerating key pairs by name'
    @ec2.key_pairs.each do |key|
       puts key.key_name 
    # puts "\tfingerprint: #{key.key_fingerprint}"   # commented for safety reasons
    end
  end

  def list_vpcs # {description: 'List Virtual Private Clouds', short: 'v'}
    puts 'List of Virtual Private Clouds'
    @ec2.vpcs.each do |vpc|
      puts "vpc.id: #{vpc.id}"
    puts"\tvpc.is_default:: #{vpc.is_default.to_s}"
    puts "\tvpc.state: #{vpc.state}"
    puts
    end
  end

  def list_groups # {description: 'List Security Groups', short: 'g'}
    puts 'List Security Groups'
    @ec2.security_groups.each do |group|
      puts "group.id: #{group.id}"
      puts "\tgroup_id: #{group.group_id}"
      puts "\tgroup name: #{group.group_name}"
      puts "\tgroup.description: #{group.description}"
      puts
    end
  end

  def describe_ec2 id # { description: 'Describe EC2 Instance', short: 'i', arg: String }
    instance = @ec2.instance id
    describe_instance instance
  end

  def list_ec2 # {description: 'List EC2 Instances', short: 'e'}
    puts 'Enumerating EC2 Instances'
    puts 'This could take some few minutes.'
    instances = @ec2.instances
    instance_count = 0
    begin
      instances.each do |instance|
        puts 'Instance of EC2'
    describe_instance instance
        instance_count += 1
    end
    rescue => err
      puts "Enumerating EC2 instances raised error:"
      puts err.class.name
      puts err.message
    end

    puts "Found #{instance_count} Instances"
  end

  def list_s3 # {description: 'List S3 Objects', short: 's'}
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
end

requestor = QueryRequestor.new

# set options from command line
options do |opts|
  requestor.set_options opts
end

 check_and_execute requestor

