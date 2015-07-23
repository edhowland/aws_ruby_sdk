# requestor.rb - method check_and_execute

def check_and_execute requestor
  unless requestor.options_given?
    what_do_you_want_to_do requestor
    else
    # now call actually requested options
begin
      requestor.execute!
rescue => err
      puts "Request raised an Error: #{err.class.name}"
  puts err.message
  0.upto(3) {|i| puts err.backtrace[i] }
end
  end
end
