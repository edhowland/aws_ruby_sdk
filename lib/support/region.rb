# region.rb - methods: region, region=, display_region

def region
  ENV['AWS_REGION']
end

def set_region(reg)
  ENV['AWS_REGION'] = reg
end

def display_region
  "Currently operating in: #{region}"
end
