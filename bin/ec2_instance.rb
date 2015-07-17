#!/usr/bin/env ruby
# ec2_instance.rb - work with ec2 instance

require_relative '../lib/application'

options('EC2 Instance Operations') do |opts|
  option opts, :create_key, 'Create Key Pair', 'k' do
    puts 'Creating key pair'
  end

  option opts, :delete_key, 'Delete Key Pair' do
    puts'Deleteing Key Pair'
  end

end
