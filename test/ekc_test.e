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

create

	make

feature -- Attributes

	ekc_db: EKC_DATABASE

feature -- Creation

	make
			-- Run the tests on the Eiffel-Kyotocabinet library ...
		do
			create ekc_db.make
			ekc_db.file_tree_create ("ekc_test_file")
			if ekc_db.last_error /= 0 then
					-- Report error
				print ("Error opening file: ")
				print (ekc_db.last_error.out)
				print ("%N")
			else
					-- Generate data ...
				fill_database
			end
		end


	fill_database
		do
		end
			
end