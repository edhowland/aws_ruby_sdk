#!/usr/bin/env ruby
# query.rb - Query AWS Resources

require_relative  '../lib/application'
require './messages'
require './requestor'

# All methods names matching option long names go here.
# E.g --list-groups : -> def list_groups
class QueryRequestor < OptionDecorator
  def initialize
    super     # mandatory call super class initializer
    @ec2 = ec2_resource
  end
  def list_regions # {description: 'List U. S. Regions', short: 'r'}
    puts <<-EOP
us-east-1
us-west-1
us-west-2
EOP
  end


  def list_keys # {description: 'List Key Pairs', short: 'k'}
    puts 'Enumerating key pairs by name'
    @ec2.key_pairs.each {|key| puts key.name }
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
      puts "\tgroup.description: #{group.description}"
      puts
    end
  end

  def list_ec2 # {description: 'List EC2 Instances', short: 'e'}
    puts 'Enumerating EC2 Instances'
    puts 'This could take some few minutes.'
    instances = @ec2.instances
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

  def list_s3 # {description: 'List S3 Objects', short: 's'}
  end
end

requestor = QueryRequestor.new

# set options from command line
options do |opts|
  requestor.set_options opts
end

 check_and_execute requestor

