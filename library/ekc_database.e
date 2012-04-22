note

		description: "Main interface to a KyotoCabinet File"

class EKC_DATABASE

inherit

	EKC_EXTERNALS

create

	make

feature -- Attributes

	last_error: INTEGER_32

feature {NONE} -- Implementation attributes

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
			l_filename.extend ('%U')
			l_ok := kc_dbopen (db_ptr, l_filename.area.base_address, Kco_create | Kco_writer | Kco_truncate)
			if l_ok = 0 then
					-- Failed ...
				last_error := Kce_misc
			else
				last_error := Kce_success
			end
		end

end