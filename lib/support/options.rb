# options.rb - options method

require 'optparse'

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
