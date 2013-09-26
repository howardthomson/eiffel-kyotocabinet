class TEST_COMMON

feature

	print_time (a_time: REAL_64)
		do
			print ("time: ")
			print (a_time.out)
			print (once "%N%N")
		end

	print_width_decimal (a_value: INTEGER_64): INTEGER
			-- Return the print width for a decimal number,
			-- no leading zeros
		do
			if     a_value >= 10000000 then
				Result := 8
			elseif a_value >= 1000000 then
				Result := 7
			elseif a_value >= 100000 then
				Result := 6
			elseif a_value >= 10000 then
				Result := 5
			elseif a_value >= 1000 then
				Result := 4
			elseif a_value >= 100 then
				Result := 3
			elseif a_value >= 10 then
				Result := 2
			else
				Result := 1
			end
		end

	print_i_width8_nl (a_value: INTEGER_64)
			-- print ("'i' in width_8")
			-- followed by a newline
		do
			print_i_width8 (a_value)
			print (once "%N")
		end

	print_i_width8 (a_value: INTEGER_64)
			-- print ("'i' in width_8")
		local
			l_str: STRING
			i, imax: INTEGER
		do
		--	create l_str.make (8)
			l_str := a_value.out
			imax := l_str.count
			from i := 1 until i > (8 - imax) loop
				print (once "0")
				i := i + 1
			end
			print (l_str)
		end

	iputchar (c: CHARACTER)
			--	print a character and flush the buffer
		do
			io.output.putchar (c)
			io.output.flush
		end

end
