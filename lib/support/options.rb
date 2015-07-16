# options.rb - options method

require 'optparse'

# return chain-case from snake_case
def chain_case snake_case
  if   snake_case =~ /(.+)_(.+)/
    [$1, $2].join('-')
  else
  snake_case
  end
end

def options banner='query', &blk
  parser = OptionParser.new do |opts|

  opts.banner =banner
      opts.separator ""
      opts.separator "Specific options:"


    opts.on( '--region region', String,  "Override Region [#{region}] operates in") do |reg|
    set_region(reg)
    end

    opts.on('-l', '--list-options', 'Display currently set options') do
    puts display_region
    exit
    end


      opts.separator ""
    yield opts if block_given?
      opts.separator ""
    
  opts.on('-h', '--help', 'Displays this help') do
    puts opts
    exit
  end

end

  parser.parse!
end


# helper method to set option
def option opts, method, description,  short=nil, &blk
  long =  chain_case(method.to_s)
  short = long[0] if short.nil?
  long = '--' + long
  short = '-' + short
  opts.on(short, long, description, &blk)
end
