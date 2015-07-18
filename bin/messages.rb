# messages.rb - various message methods

def what_do_you_want_to_do rf
  puts <<-EOM
No Options given.
What do you want to do?
Available options are:

#{rf.option_list}
EOM
end
