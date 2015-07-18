# read_line.rb -  method read_line from file

def read_line fname, lineno
  count = 0
  result = ''
  File.open(fname) do |f|
    until count == lineno
      result = f.gets
      count += 1
    end    

  end

  result.chomp
end

