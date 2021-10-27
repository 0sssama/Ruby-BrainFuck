require 'io/console'

def compile(code)
	arr = [0]
	brackets = []
	brackets_index = -1
	arr_index = 0
	code_index = 0
	while code_index < code.length
		case code[code_index]
			when '>'
				arr_index += 1
				if arr_index == arr.length
					arr[arr_index] = 0
				end 
			when '<'
				arr_index -= 1;
				if arr_index < 0
					arr_index = arr.length - 1
				end
			when '.'
				print arr[arr_index].chr
			when ','
				input = STDIN.getch
				if input == "\u0003" # Ctrl + C
					abort "[COMPILER] Aborting..."
				end
				arr[arr_index] = input.ord
			when '+'
				arr[arr_index] += 1
			when '-'
				if arr[arr_index] != 0
					arr[arr_index] -= 1
				end
			when '['
				brackets_index += 1
				brackets[brackets_index] = code_index
			when ']'
				if brackets_index == -1
					abort "[COMPILER] Closing unopened loop error at col:#{code_index} -> #{code[code_index]} <-"
				end
				if arr[arr_index] != 0
					code_index = brackets[brackets_index]
				else
					brackets[brackets_index] = -1
					brackets_index -= 1
				end
		end
		code_index += 1
	end
end

def	main(filename)
	begin
		file = File.open(filename)
	rescue
		abort "[COMPILER] No such file -> #{filename} <-."
	else
		content = file.read
		compile(content)
		file.close
	end
end

args = ARGV

file = args[0]
main(file)