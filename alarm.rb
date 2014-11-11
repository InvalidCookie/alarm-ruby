require 'win32/sound'
include Win32

@data = []
@active = []
@alarm_off = false

unless File.exist?('data.txt')
  File.new('data.txt', 'w+')
  puts "Data file created!"
else
	puts "Data file found..."
end

unless File.zero?('data.txt')
	File.open('data.txt', 'r') do |f|
		f.each_line do |con|
			@data << con
		end #each_line end
		puts "Data file loaded!"
	end #file end
else
	puts "Data file empty."
end #unless end

def alarm
	Thread.new do
		while true
			Sound.beep(100, 500) and Sound.play('Liar.wav') and @alarm_off = false if @alarm_off
			sleep(2)
		end
	end
end

def clock
	Thread.new do
		while true
			time = Time.now.strftime("%k, %M")
			contain = @active.index{|s| s.include?(time)}
			@alarm_off = true and contain = nil if !contain.nil?
			sleep(31)
		end
	end
end

def start
	puts "what alarm would you like to start?"
	alarm_start = gets.chomp
	contain = @data.index{|s| s.include?(alarm_start)}
	if !contain.nil?
		@active << @data[contain]
		puts "#{alarm_start} has been started"
	else
		puts "#{alarm_start} does not exist"
	end
end

def stop
	puts "what alarm would you like to stop?"
	alarm_stop = gets.chomp
	contain = @active.index{|s| s.include?(alarm_stop)}
	if !contain.nil?
		@active.delete_at(contain)
		puts "#{alarm_stop} has been stopped"
	else
		puts "#{alarm_start} is not active"
	end
end

def list
	puts @data
end

def active
	puts @active
end

def set
	puts "What will be the alarm name?"
	alarm_name = gets.chomp
	puts "What time will it go off? (military time)"
	alarm_hour = gets.chomp
	puts "What minutes will it go off?"
	alarm_minute = gets.chomp
	alarm_set = "#{alarm_name} , #{alarm_hour}, #{alarm_minute}"
	@data << alarm_set
	save
end

#editing the alarm would be pointless, its easier to delete then add it again,
#ill keep the code for it here anyway incase i want to change it sometime.
def edit 
	puts "What alarm would you like to edit?"
	edit_choice = gets.chomp
	@data.index{|s| s.include?(edit_choice)}
	if !edit_choice.nil?
		puts "What will be the alarm name?"
		alarm_name = gets.chomp
		puts "What time will it go off? (military time)"
		alarm_hour = gets.chomp
		puts "What minutes will it go off?"
		alarm_minute = gets.chomp
		alarm_set = "#{alarm_name} , #{alarm_hour}, #{alarm_minute}"
		@data << alarm_set
		save
	else
		puts "That alarm does not exist"
	end
end

def delete
	puts "What would you like to delete?"
	del_choice = gets.chomp
	del_spot = @data.index{|s| s.include?(del_choice)}
	if !del_spot.nil?
		@data.delete_at(del_spot)
		puts "#{del_choice} was removed"
		save
	else 
		puts "#{del_choice} was not found"
	end
end

def save
	File.open('data.txt', 'w+') do |f|
	 f.puts @data
	end
end

clock
alarm

puts ""
while true
puts "What would you like to do with an alarm?"
puts "-start"
puts "-stop"
puts "-list    (list all alarms)"
puts "-active  (lists all active alarms)"
puts "-set"
puts "-delete"
puts "-exit"
choice = gets.chomp.downcase
case choice
	when "start"
		start
	when "stop"
		stop
	when "list"
		list
	when "active"
		active
	when "set"
		set
	when "delete"
		delete
	when "exit"
		save
		Process.exit
	else 
		puts "Invalid Cookie"
end #case end
puts ""
end #loop end


=begin
alarm = "alarm name"
day = time.strftime("%^A")
hour = time.strftime("%k")
minute = time.strftime("%M")
open('log.txt', 'w') do |f|
 f.puts "#{alarm} ; #{day} ; #{hour} ; #{minute}"
end
=end

=begin
time = Time.new

puts time.strftime("%^A, %k, %M")
=end

#ability set sound effect

#Sound.play('Liar.wav')

#Sound.beep(100, 500)