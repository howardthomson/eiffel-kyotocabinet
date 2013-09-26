note

		description: "Eiffel-Kyotocabinet Cursor"

class EKC_CURSOR

inherit

	EKC_EXTERNALS

create {EKC_DATABASE}

	make

feature -- Attributes

	last_ok: BOOLEAN

feature {NONE} -- Implementation attributes

	cp: POINTER
			-- Cursor Pointer
	
feature -- Creation

	make (a_database: EKC_DATABASE)
			-- Create a Cursor for an Eiffel-Kyotocabinet key/value database
		do
			cp := kc_dbcursor (a_database.db_ptr)
		end

feature -- Disposal

	dispose
			-- Finished with this cursor
		do
			if cp /= default_pointer then
				kc_curdel (cp)
				cp := default_pointer
			end
		end


feature -- Sequence

	start
			-- Start from the first entry, for forward scan
		do
			last_ok := 0 /= kc_curjump (cp)
		end

	forth
			-- Move cursor forward one entry
		do
			last_ok := 0 /= kc_step (cp)
		end

	back
			-- Move cursor back one entry
		do
			last_ok := 0 /= kc_curstepback (cp)
		end

	finish
			-- Move cursor to last entry, for backward scan
		do
			last_ok := 0 /= kc_curjumpback (cp)
		end

feature -- Sequence with key ...

	start_key (a_key: STRING_8)
			-- Move cursor to first entry with key 'a_key'
		do
			last_ok := 0 /= kc_curjumpkey (cp, a_key.area.base_address, a_key.count)
		end

	finish_key (a_key: STRING_8)
			-- Move cursor to last entry with key 'a_key'
		do
			last_ok := 0 /= kc_curjumpbackkey (cp, a_key.area.base_address, a_key.count)
		end

end
	