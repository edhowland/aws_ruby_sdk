# describe_image.rb - method describe_image image

def describe_image image
  puts 'Image created successfully'
  puts "Image ID: #{image.image_id}"
  puts "Image Name: #{image.name}"
  puts "Description: #{image.description}"
  puts "Creation Date: #{image.creation_date}"
  puts "State of Image: #{image.state}"
  puts "Publicly Launchable: #{image.public.to_s}"
end
