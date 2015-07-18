# requestor.rb - method check_and_execute

def check_and_execute requestor
  unless requestor.options_given?
    what_do_you_want_to_do requestor
    else
    # now call actually requested options
    requestor.execute!
  end
end
