# region.rb - method load_region

# load_region_via_require
def load_region_via_require
  require File.expand_path('~/.aws/region.rb')
end

# load_region - selects which method to region into enviroment
def load_region
  load_region_via_require
end
