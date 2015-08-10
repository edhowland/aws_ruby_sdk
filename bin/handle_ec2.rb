# handle_ec2.rb - method handle_ec2

# runs an ec2 operation within begin/rescue block
def handle_ec2 ec2, &blk
  begin
    yield ec2 if block_given?

  rescue => err
    puts 'EC2 operation raised an error:'
    puts err.message
  end
end
