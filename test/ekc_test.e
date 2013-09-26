note

		description: "Test class for the Eiffel-Kyotocabinet library"

	todo: "[
		Use a random number generator to generate content for the storage system.

		Version 1:
			Use RNG to generate SHA1 hash / size virtual data chunks
			Allocate data chunks to virtual storage
			Store virtual storage location to the database, with dedup

		Version 2:
			Use RNG to generate chunk-size / chunk-data
			Generate SHA1 hash for the chunk-data
			Allocate the chunk-data to actual storage
			Store the storage location to the database, with dedup
			Time the process ...
	]"

class EKC_TEST

inherit

	KL_SHARED_EXCEPTIONS
	TEST_COMMON

create

	make

feature -- Attributes

	ekc_db: EKC_DATABASE

	start_time, end_time: REAL_64

	db_error: BOOLEAN

feature -- Creation

	make
			-- Run the tests on the Eiffel-Kyotocabinet library ...
		do
			print ("Running EKC_TEST.make ...%N")
--			test_counting
			create ekc_db.make
			ekc_db.file_tree_create ("ekc_test_file")
			if ekc_db.last_error /= 0 then
					-- Report error
				print ("Error opening file: ")
				print (ekc_db.last_error.out)
				print ("%N")
			else
					-- Generate data ...
				set_records
				add_records
				append_records
				get_records
				traverse_records_inner_iterator
				traverse_records_outer_cursor
				synchronize_database
				remove_records
			end
		end

	test_counting
		local
			i: INTEGER_64
		do
			create ekc_db.make
			start_time := ekc_db.time
			from i := 1 until i > 100_000_000 loop
				i := i + 1
			end
			end_time := ekc_db.time
			print_time (end_time - start_time)
			Exceptions.die (0)
		end

	test_count: INTEGER_64 = 10000000

	key_buffer_internal: STRING_8
		once
			create Result.make (64)
		end

	key_buffer (a_i: INTEGER_64): STRING_8
			-- Generate 8-char string value for 'i'
		local
			i: INTEGER
			w: INTEGER
		do
			Result := key_buffer_internal; Result.wipe_out
			w := print_width_decimal (a_i)
			from i := w until i > 8 loop
				Result.append_character ('0')
				i := i + 1
			end
			Result.append_integer_64 (a_i)
		end

	set_records
			-- 
		local
			i: INTEGER_64
			kbuf: STRING_8
		do
			print ("Set records ...%N")
			start_time := ekc_db.time
			from i := 1 until db_error or else i > test_count loop
				kbuf := key_buffer (i)
				ekc_db.put (kbuf, kbuf)
				if not ekc_db.last_ok then
					db_error := True
					report_db_error
				end
				i := i + 1
				if test_count > 250 and then i \\ (test_count // 250) = 0 then
					report_i (i)
				end
			end
			end_time := ekc_db.time
			print_time (end_time - start_time)
		end

	add_records
		local
			i: INTEGER_64
			kbuf: STRING_8
		do
			print ("Adding records ...%N")
			start_time := ekc_db.time
			from i := 1 until db_error or else i > test_count loop
				kbuf := key_buffer (i)
				ekc_db.put_new (kbuf, kbuf)
				if not ekc_db.last_ok then
					db_error := True
					report_db_error
				end
				i := i + 1
				if test_count > 250 and then i \\ (test_count // 250) = 0 then
					report_i (i)
				end
			end
			end_time := ekc_db.time
			print_time (end_time - start_time)
		end
		
	append_records
		do
		end
		
	get_records
		do
		end
		
	traverse_records_inner_iterator
		do
		end
		
	traverse_records_outer_cursor
		do
		end
		
	synchronize_database
		do
		end
		
	remove_records
		local
			i: INTEGER_64
			kbuf: STRING_8
		do
			print ("Remove records ...%N")
			start_time := ekc_db.time
			from i := 1 until db_error or else i > test_count loop
				kbuf := key_buffer (i)
				ekc_db.remove (kbuf)
				if not ekc_db.last_ok then
					db_error := True
					report_db_error
				end
				i := i + 1
				if test_count > 250 and then i \\ (test_count // 250) = 0 then
					report_i (i)
				end
			end
			end_time := ekc_db.time
			print_time (end_time - start_time)
		end

feature -- Reporting

	report_i (i: INTEGER_64)
		do
  			iputchar ('.')
  			if i = test_count or else i \\ (test_count // 10) = 0 then
				print (once " (")
				print_i_width8 (i)
				print (once ")%N")
			end
		end

	report_db_error
		do
		end

end