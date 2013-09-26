note

		description: "Main interface to a KyotoCabinet File"


	todo: "[
		Inherit from DS_TABLE; several deferred routines to define
	]"

class EKC_DATABASE

inherit

	EKC_EXTERNALS
--	DS_TABLE [ STRING_8, STRING_8 ]

create

	make

feature -- Attributes

	last_error: INTEGER_32

	last_ok: BOOLEAN

feature {EKC_CURSOR} -- Implementation attributes

	db_ptr: POINTER
			-- Link to the KyotoDatabase object

feature -- Creation

	make
			-- Create the database object ...
		do
			db_ptr := kc_dbnew
		end

feature -- File create/open

	file_tree_create (a_name: STRING)
			-- Create a file tree database
			-- a_name is the base name of the file
			-- the filesystem name will be a_name + ".kct"
		local
			l_filename: STRING
			l_ok: INTEGER_32
		do
			create l_filename.make_from_string (a_name)
			l_filename.append (".kct")
				-- Extend with NUL byte
			l_filename.extend ('%U')
			l_ok := kc_dbopen (db_ptr, l_filename.area.base_address, Kco_create | Kco_writer | Kco_truncate)
			if l_ok = 0 then
					-- Failed ...
				last_error := Kce_misc
			else
				last_error := Kce_success
			end
		end

feature -- Queries

	size: INTEGER_64
			-- Size of database file, in bytes
			-- -1 on error
		do
			Result := kc_dbsize (db_ptr)
		end

	time: REAL_64
			-- Current time (?) from KyotoCabinet routine ...
		do
			Result := kc_time
		end

	status: ARRAY [ STRING ]
			-- ...
		local
			l_ptr: POINTER
			
		do
			l_ptr := kc_dbstatus (db_ptr)
				-- Split string into components ...

			-- TODO
			kc_free (l_ptr)
		end

	at alias "@", item (k: STRING_8): STRING_8
			-- Item associated with `k'
		do
		end

	has (a_key: STRING_8): BOOLEAN
		do
		--	TODO
		end

feature -- Commands

	put_new (a_key, a_value: STRING_8)
			-- ...
		do
	    	last_ok := 0 /= kc_dbset (db_ptr, a_key.area.base_address, a_key.count, a_value.area.base_address, a_value.count)
		end

	put (a_key, a_value: STRING_8)
			-- ...
		do
	    	last_ok := 0 /= kc_dbadd (db_ptr, a_key.area.base_address, a_key.count, a_value.area.base_address, a_value.count)
		end

	remove (a_key: STRING_8)
			-- Delete the key/value pair keyed by 'a_key'
		do
			last_ok := 0 /= kc_dbremove (db_ptr, a_key.area.base_address, a_key.count)
		end

end