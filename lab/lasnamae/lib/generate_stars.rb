starfield = String.new
print "Enter color number (1..3):"
colornum = gets.chop
100.times do 
  starfield += "#{rand(1400)}px #{rand(2000)}px $color-star-#{colornum}, "
end

starfield = starfield.chop.chop + ";"

File.open('tmp', 'w') { |file| file.write(starfield) }
puts "OK!"