
note

	description: "EiffeKyotoCabinet Externals"

class EKC_EXTERNALS

feature -- Constants

		-- Error codes:
	Kce_success	: INTEGER = 0	-- Success					0 or 1 ?????
	Kce_noimpl	: INTEGER = 1	-- Not Implemented
	Kce_invalid	: INTEGER = 2	-- Invalid operation
	Kce_norepos	: INTEGER = 3	-- No repository
	Kce_broken	: INTEGER = 4	-- Broken file
	Kce_duprec	: INTEGER = 5	-- Record duplication
	Kce_norec	: INTEGER = 6	-- No record
	Kce_logic	: INTEGER = 7	-- Logical inconsistency
	Kce_system	: INTEGER = 8	-- System error
	Kce_misc	: INTEGER = 15	-- Miscellaneous error

		-- Open modes:
	Kco_reader	: INTEGER = 1
	Kco_writer	: INTEGER = 2
	Kco_create	: INTEGER = 4
	Kco_truncate: INTEGER = 8
	Kco_autotran: INTEGER = 16
	Kco_autosync: INTEGER = 32
	Kco_nolock	: INTEGER = 64
	Kco_trylock	: INTEGER = 128
	Kco_norepair: INTEGER = 256

		-- Merge modes:
	Kcm_set		: INTEGER = 0
	Kcm_add		: INTEGER = 1
	Kcm_replace	: INTEGER = 2
	Kcm_append	: INTEGER = 3
	
feature -- Routines

	kc_malloc (a_size: INTEGER_64): POINTER
			-- Allocate a region of memory.
			-- @param size the size of the region.
			-- @return the pointer to the allocated region.  The region of the return value should be
			-- released with the kcfree function when it is no longer in use.

		external "C"
		alias "kcmalloc"
		end

	kc_free (a_pointer: POINTER)
			-- Free a region of memory, allocated from the library
		external "C"
		alias "kcfree"
		end


	kc_time: REAL_64
			-- Get time-of-day in seconds
			-- Accuracy to microseconds ...
		external "C"
		alias "kctime"
		end

	kc_atoi (a_c_string: POINTER): INTEGER_64
			-- Convert a string to an integer
			-- Return 0 if not a numeric expression
		external "C"
		alias "kcatoi"
		end

	kc_atoix (a_c_string: POINTER): INTEGER_64
			--	Convert a string with a metric prefix to an integer.
			--	@param str the string, which can be trailed by a binary metric prefix.  "K", "M", "G", "T",
			--	"P", and "E" are supported.  They are case-insensitive.
			--	@return the integer.  If the string does not contain numeric expression, 0 is returned.  If
			--	the integer overflows the domain, INT64_MAX or INT64_MIN is returned according to the
			--	sign.
		external "C"
		alias "kcatoix"
		end
	
	kc_atof (a_c_string: POINTER): REAL_64
			--	Convert a string to a real number.
			--	@param str specifies the string.
			--	@return the real number.
			--	If the string does not contain numeric expression, 0.0 is returned.
		external "C"
		alias "kcatof"
		end

	kc_hashmurmur (a_buffer: POINTER; a_size: INTEGER_64): NATURAL_64
			--	Get the hash value by MurMur hashing.
			--	@param buf the source buffer.
			--	@param size the size of the source buffer.
			--	@return the hash value.
		external "C"
		alias "kchashmurmur"
		end 

	kc_hashfnv (a_buffer: POINTER; a_size: INTEGER_64): NATURAL_64
			--	Get the hash value by FNV hashing.
			--	@param buf the source buffer.
			--	@param size the size of the source buffer.
			--	@return the hash value.
		external "C"
		alias "kchashfnv"
		end

	kc_nan: REAL_64
			--	Get the quiet Not-a-Number value.
			--	@return the quiet Not-a-Number value.
		external "C"
		alias "kcnan"
		end


	kc_inf: REAL_64
			--	Get the positive infinity value.
			--	@return the positive infinity value.
		external "C"
		alias "kcinf"
		end

	kc_chknan (a_number: REAL_64): INTEGER_32
			--	Check a number is a Not-a-Number value.
			--	@return true for the number is a Not-a-Number value, or false if not.
		external "C"
		alias "kcchknan"
		end

	kc_chkinf (a_number: REAL_64): INTEGER_32
			--	Check a number is an infinity value.
			--	@return true for the number is an infinity value, or false if not.
		external "C"
		alias "kcchkinf"
		end

	kc_ecodename (a_code: INTEGER_32): POINTER
			--	Get the readable string of an error code.
			--	@param code the error code.
			--	@return the readable string of the error code.
		external "C"
		alias "kcecodename"
		end

	kc_dbnew: POINTER
			--	Create a database object.
			--	@return the created database object.
			--	@note The object of the return value should be released with the kcdbdel function when it is
			--	no longer in use.
		external "C"
		alias "kcdbnew"
		end

	kc_dbdel (a_db_pointer: POINTER)
			--	Destroy a database object.
			--	@param db the database object.
		external "C"
		alias "kcdbdel"
		end

	kc_dbopen (a_db_pointer: POINTER; a_path: POINTER; a_mode: INTEGER_32): INTEGER_32
			--	Open a database file.
			--	@param db a database object.
			--	@param path the path of a database file.
			--		If it is "-", the database will be a prototype hash database. 
			--		If it is "+", the database will be a prototype tree database.
			--		If it is "*", the database will be a cache hash database.
			--		If it is "%", the database will be a cache tree database.
			--		If its suffix is ".kch", the database will be a file hash database.
			--		If its suffix is ".kct", the database will be a file tree database.
			--		If its suffix is ".kcd", the database will be a directory hash database.
			--		If its suffix is ".kcf", the database will be a directory tree database.
			--		Otherwise, this function fails.
			--	Tuning parameters can trail the name, separated by "#".
			--		Each parameter is composed of the name and the value, separated by "=".
			--		If the "type" parameter is specified, the database type is determined by the value
			--		in "-", "+", "*", "%", "kch", "kct", "kcd", and "kcf".
			--	All database types support the logging parameters of "log", "logkinds", and "logpx".
			--	The prototype hash database and the prototype tree database do not support any other tuning parameter.
			--	The cache hash database supports "opts", "bnum", "zcomp", "capcount", "capsize", and "zkey".
			--	The cache tree database supports all parameters of the cache hash database
			--	except for capacity limitation, and supports "psiz", "rcomp", "pccap" in addition.
			--	The file hash database supports "apow", "fpow", "opts", "bnum", "msiz", "dfunit", "zcomp", and
			--	"zkey".  The file tree database supports all parameters of the file hash database and
			--	"psiz", "rcomp", "pccap" in addition.  The directory hash database supports "opts", "zcomp",
			--	and "zkey".  The directory tree database supports all parameters of the directory hash
			--	database and "psiz", "rcomp", "pccap" in addition.
			--	@param mode the connection mode.  KCOWRITER as a writer, KCOREADER as a reader.
			--	The following may be added to the writer mode by bitwise-or:
			--		KCOCREATE, which means it creates a new database if the file does not exist,
			--		KCOTRUNCATE, which means it creates a new database regardless if the file exists,
			--		KCOAUTOTRAN, which means each updating operation is performed in implicit transaction,
			--		KCOAUTOSYNC, which means each updating operation is followed by implicit synchronization with the file system.
			--	The following may be added to both of the reader mode and the writer mode by bitwise-or:
			--		KCONOLOCK, which means it opens the database file without file locking,
			--		KCOTRYLOCK, which means locking is performed without blocking,
			--		KCONOREPAIR, which means the database file is not repaired implicitly even if file destruction is detected.
			--	@return true on success, or false on failure.
			--	@note The tuning parameter "log" is for the original "tune_logger" and the value specifies
			--	the path of the log file, or "-" for the standard output, or "+" for the standard error.
			--	"logkinds" specifies kinds of logged messages and the value can be "debug", "info", "warn",
			--	or "error".  "logpx" specifies the prefix of each log message.  "opts" is for "tune_options"
			--	and the value can contain "s" for the small option, "l" for the linear option, and "c" for
			--	the compress option.  "bnum" corresponds to "tune_bucket".  "zcomp" is for "tune_compressor"
			--	and the value can be "zlib" for the ZLIB raw compressor, "def" for the ZLIB deflate
			--	compressor, "gz" for the ZLIB gzip compressor, "lzo" for the LZO compressor, "lzma" for the
			--	LZMA compressor, or "arc" for the Arcfour cipher.  "zkey" specifies the cipher key of the
			--	compressor.  "capcount" is for "cap_count".  "capsize" is for "cap_size".  "psiz" is for
			--	"tune_page".  "rcomp" is for "tune_comparator" and the value can be "lex" for the lexical
			--	comparator or "dec" for the decimal comparator.  "pccap" is for "tune_page_cache".  "apow"
			--	is for "tune_alignment".  "fpow" is for "tune_fbp".  "msiz" is for "tune_map".  "dfunit" is
			--	for "tune_defrag".
			--	Every opened database must be closed by the kcdbclose method when it is no longer in use.
			--	It is not allowed for two or more database objects in the same process to
			--		keep their connections to the same database file at the same time.
 		external "C"
 		alias "kcdbopen"
 		end

	kc_dbclose (a_db_ptr: POINTER): INTEGER_32
			--	Close the database file.
			--	@param db a database object.
			--	@return true on success, or false on failure.
		external "C"
		alias "kcdbclose"
		end

	kc_dbecode (a_db_ptr: POINTER): INTEGER_32
			--	Get the code of the last happened error.
			--	@param db a database object.
			--	@return the code of the last happened error.
		external "C"
		alias "kcdbecode"
		end

	kc_dbemsg (a_db_ptr: POINTER): POINTER
			--	Get the supplement message of the last happened error.
			--	@param db a database object.
			--	@return the supplement message of the last happened error.
		external "C"
		alias "kcdbemsg"
		end

	kc_dbaccept (a_db_ptr: POINTER;	a_kbuf: POINTER; a_ksiz: INTEGER_64; 
					a_full_proc, a_empty_proc: POINTER;
					a_opq: POINTER;
					a_writable: INTEGER_32): INTEGER_32
			--	Accept a visitor to a record.
			--	@param db a database object.
			--	@param kbuf the pointer to the key region.
			--	@param ksiz the size of the key region.
			--	@param fullproc a call back function to visit a record.
			--	@param emptyproc a call back function to visit an empty record space.
			--	@param opq an opaque pointer to be given to the call back functions.
			--	@param writable true for writable operation, or false for read-only operation.
			--	@return true on success, or false on failure.
			--	@note the operation for each record is performed atomically and other threads accessing the
			--	same record are blocked.
		external "C"
		alias "kcdbaccept"
		end

	kc_dbiterate (a_db_ptr: POINTER; a_full_proc: POINTER; a_opq: POINTER; a_writable: INTEGER_32): INTEGER_32
			--	Iterate to accept a visitor for each record.
			--	@param db a database object.
			--	@param fullproc a call back function to visit a record.
			--	@param opq an opaque pointer to be given to the call back function.
			--	@param writable true for writable operation, or false for read-only operation.
			--	@return true on success, or false on failure.
			--	@note the whole iteration is performed atomically and other threads are blocked.
		external "C"
		alias "kcdbiterate"
		end

	kc_dbset (a_db_ptr: POINTER; a_kbuf: POINTER; a_ksiz: INTEGER_64; a_vbuf: POINTER; a_vsiz: INTEGER_64): INTEGER_32
			--	Set the value of a record.
			--	@param db a database object.
			--	@param kbuf the pointer to the key region.
			--	@param ksiz the size of the key region.
			--	@param vbuf the pointer to the value region.
			--	@param vsiz the size of the value region.
			--	@return true on success, or false on failure.
			--	@note If no record corresponds to the key, a new record is created.  If the corresponding
			--	record exists, the value is overwritten.
		external "C"
		alias "kcdbset"
		end

	kc_dbadd (a_db_ptr: POINTER; a_kbuf: POINTER; a_ksiz: INTEGER_64; a_vbuf: POINTER; a_vsiz: INTEGER_64): INTEGER_32
			--	Add a record.
			--	@param db a database object.
			--	@param kbuf the pointer to the key region.
			--	@param ksiz the size of the key region.
			--	@param vbuf the pointer to the value region.
			--	@param vsiz the size of the value region.
			--	@return true on success, or false on failure.
			--	@note If no record corresponds to the key, a new record is created.  If the corresponding
			--	record exists, the record is not modified and false is returned.
		external "C"
		alias "kcdbadd"
		end

	kc_dbreplace (a_db_ptr: POINTER; a_kbuf: POINTER; a_ksiz: INTEGER_64; a_vbuf: POINTER; a_vsiz: INTEGER_64): INTEGER_32
			--   Replace the value of a record.
			--   @param db a database object.
			--   @param kbuf the pointer to the key region.
			--   @param ksiz the size of the key region.
			--   @param vbuf the pointer to the value region.
			--   @param vsiz the size of the value region.
			--   @return true on success, or false on failure.
			--   @note If no record corresponds to the key, no new record is created and false is returned.
			--   If the corresponding record exists, the value is modified.
		external "C"
		alias "kcdbreplace"
		end

	kc_dbappend (a_db_ptr: POINTER; a_kbuf: POINTER; a_ksiz: INTEGER_64; a_vbuf: POINTER; a_vsiz: INTEGER_64): INTEGER_32
			--   Append to the value of a record.
			--   @param db a database object.
			--   @param kbuf the pointer to the key region.
			--   @param ksiz the size of the key region.
			--   @param vbuf the pointer to the value region.
			--   @param vsiz the size of the value region.
			--   @return true on success, or false on failure.
			--   @note If no record corresponds to the key, a new record is created.  If the corresponding
			--   record exists, the given value is appended at the end of the existing value.
 		external "C"
		alias "kcdbappend"
		end

	kc_dbincrint (a_db_ptr: POINTER; a_kbuf: POINTER; a_ksiz: INTEGER_64; a_num: INTEGER_64): INTEGER_64
			--   Add a number to the numeric value of a record.
			--   @param db a database object.
			--   @param kbuf the pointer to the key region.
			--   @param ksiz the size of the key region.
			--   @param num the additional number.
			--   @return the result value, or INT64_MIN on failure.
 		external "C"
 		alias "kcdbincrint"
 		end

	kc_dbincrdouble (a_db_ptr: POINTER; a_kbuf: POINTER; a_ksiz: INTEGER_64; double a_num: REAL_64): REAL_64
			--   Add a number to the numeric value of a record.
			--   @param db a database object.
			--   @param kbuf the pointer to the key region.
			--   @param ksiz the size of the key region.
			--   @param num the additional number.
			--   @return the result value, or Not-a-number on failure.
 		external "C"
 		alias "kcdbincrdouble"
 		end

	kc_dbcas (a_db_ptr: POINTER; a_kbuf: POINTER; a_ksiz: INTEGER_64;
		a_nvbuf: POINTER; a_nvsiz: INTEGER_64; a_ovbuf: POINTER; a_ovsiz: INTEGER_64): INTEGER_32
			--   Perform compare-and-swap.
			--   @param db a database object.
			--   @param kbuf the pointer to the key region.
			--   @param ksiz the size of the key region.
			--   @param ovbuf the pointer to the old value region.  NULL means that no record corresponds.
			--   @param ovsiz the size of the old value region.
			--   @param nvbuf the pointer to the new value region.  NULL means that the record is removed.
			--   @param nvsiz the size of new old value region.
			--   @return true on success, or false on failure.
		external "C"
		alias "kcdbcas"
		end

	kc_dbremove (a_db_ptr: POINTER; a_kbuf: POINTER; a_ksiz: INTEGER_64): INTEGER_32
			--   Remove a record.
			--   @param db a database object.
			--   @param kbuf the pointer to the key region.
			--   @param ksiz the size of the key region.
			--   @return true on success, or false on failure.
			--   @note If no record corresponds to the key, false is returned.
		external "C"
		alias "kcdbremove"
		end

	kc_dbget (a_db_ptr: POINTER; a_kbuf: POINTER; a_ksiz: INTEGER_64; a_sp: POINTER): POINTER
			--   Retrieve the value of a record.
			--   @param db a database object.
			--   @param kbuf the pointer to the key region.
			--   @param ksiz the size of the key region.
			--   @param sp the pointer to the variable into which the size of the region of the return
			--   value is assigned.
			--   @return the pointer to the value region of the corresponding record, or NULL on failure.
			--   @note If no record corresponds to the key, NULL is returned.  Because an additional zero
			--   code is appended at the end of the region of the return value, the return value can be
			--   treated as a C-style string.  The region of the return value should be released with the
			--   kcfree function when it is no longer in use.
		external "C"
		alias "kcdbget"
		end
		
	kc_dbgetbuf (a_db_ptr: POINTER; a_kbuf: POINTER; a_ksiz: INTEGER_64; a_vbuf: POINTER; a_max: INTEGER_64): INTEGER_32
			--   Retrieve the value of a record.
			--   @param db a database object.
			--   @param kbuf the pointer to the key region.
			--   @param ksiz the size of the key region.
			--   @param vbuf the pointer to the buffer into which the value of the corresponding record is
			--   written.
			--   @param max the size of the buffer.
			--   @return the size of the value, or -1 on failure.
 		external "C"
 		alias "kcdbgetbuf"
 		end

	kc_dbclear (a_db_ptr: POINTER): INTEGER_32
			--   Remove all records.
			--   @param db a database object.
			--   @return true on success, or false on failure.
 		external "C"
 		alias "kcdbclear"
 		end

	kc_dbsync (a_db_ptr: POINTER; a_hard: INTEGER_32; a_file_proc: POINTER; a_opq: POINTER): INTEGER_32
			--   Synchronize updated contents with the file and the device.
			--   @param db a database object.
			--   @param hard true for physical synchronization with the device, or false for logical
			--   synchronization with the file system.
			--   @param proc a postprocessor call back function.  If it is NULL, no postprocessing is
			--   performed.
			--   @param opq an opaque pointer to be given to the call back function.
			--   @return true on success, or false on failure.
 		external "C"
 		alias "kcdbsync"
 		end
 		
	kc_dbcopy (a_db_ptr: POINTER; a_dest: POINTER): INTEGER_32
			--   Create a copy of the database file.
			--   @param db a database object.
			--   @param dest the path of the destination file.
			--   @return true on success, or false on failure.
 		external "C"
 		alias "kcdbcopy"
 		end

	kc_dbbegintran (a_db_ptr: POINTER; a_hard: INTEGER_32): INTEGER_32
			--   Begin transaction.
			--   @param db a database object.
			--   @param hard true for physical synchronization with the device, or false for logical
			--   synchronization with the file system.
			--   @return true on success, or false on failure.
 		external "C"
 		alias "kcdbbegintran"
 		end

	kc_dbbegintrantry (a_db_ptr: POINTER; a_hard: INTEGER_32): INTEGER_32
			--   Try to begin transaction.
			--   @param db a database object.
			--   @param hard true for physical synchronization with the device, or false for logical
			--   synchronization with the file system.
			--   @return true on success, or false on failure.
 		external "C"
 		alias "kcdbbegintrantry"
 		end

	kc_dbendtran (a_db_ptr: POINTER; a_commit: INTEGER_32): INTEGER_32
			--   End transaction.
			--   @param db a database object.
			--   @param commit true to commit the transaction, or false to abort the transaction.
			--   @return true on success, or false on failure.
 		external "C"
 		alias "kcdbendtran"
 		end

	kc_dbdumpsnap (a_db_ptr: POINTER; a_dest: POINTER): INTEGER_32
			--   Dump records into a file.
			--   @param db a database object.
			--   @param dest the path of the destination file.
			--   @return true on success, or false on failure.
		external "C"
		alias "kcdbdumpsnap"
		end


	kc_dbloadsnap (a_db_ptr: POINTER; a_src: POINTER): INTEGER_32
			--   Load records from a file.
			--   @param db a database object.
			--   @param src the path of the source file.
			--   @return true on success, or false on failure.
 		external "C"
		alias "kcdbloadsnap"
		end

	kc_dbcount (a_db_ptr: POINTER): INTEGER_64
			--   Get the number of records.
			--   @param db a database object.
			--   @return the number of records, or -1 on failure.
 		external "C"
		alias "kcdbcount"
		end

	kc_dbsize (a_db_ptr: POINTER): INTEGER_64
			--   Get the size of the database file.
			--   @param db a database object.
			--   @return the size of the database file in bytes, or -1 on failure.
 		external "C"
		alias "kcdbsize"
		end

	kc_dbpath (a_db_ptr: POINTER): POINTER
			--   Get the path of the database file.
			--   @param db a database object.
			--   @return the path of the database file, or an empty string on failure.
			--   @note The region of the return value should be released with the kcfree function when it is
			--   no longer in use.
 		external "C"
		alias "kcdbpath"
		end

	kc_dbstatus (a_db_ptr: POINTER): POINTER
			--   Get the miscellaneous status information.
			--   @param db a database object.
			--   @return the result string of tab saparated values, or NULL on failure.  Each line consists of
			--   the attribute name and its value separated by a tab character.
			--   @note The region of the return value should be released with the kcfree function when it is
			--   no longer in use.
 		external "C"
		alias "kcdbstatus"
		end

	kc_dbmatchprefix (a_db_ptr: POINTER; a_prefix: POINTER; a_strary: POINTER; a_max: INTEGER_64): INTEGER_64
			--   Get keys matching a prefix string.
			--   @param db a database object.
			--   @param prefix the prefix string.
			--   @param strary an array to contain the result.  Its size must be sufficient.
			--   @param max the maximum number to retrieve.
			--   @return the number of retrieved keys or -1 on failure.
			--   @note The region of each element of the result should be released with the kcfree function
			--   when it is no longer in use.
 		external "C"
		alias "kcdbmatchprefix"
		end

	kc_dbmatchregex (a_db_ptr: POINTER; a_regex: POINTER; a_strary: POINTER; a_max: INTEGER_64): INTEGER_64
			--   Get keys matching a regular expression string.
			--   @param db a database object.
			--   @param regex the regular expression string.
			--   @param strary an array to contain the result.  Its size must be sufficient.
			--   @param max the maximum number to retrieve.
			--   @return the number of retrieved keys or -1 on failure.
			--   @note The region of each element of the result should be released with the kcfree function
			--   when it is no longer in use.
 		external "C"
		alias "kcdbmatchregex"
		end

	kc_dbmerge (a_db_ptr: POINTER; a_srcary: POINTER; a_srcnum: INTEGER_64; a_mode: NATURAL_32): INTEGER_32
			--   Merge records from other databases.
			--   @param db a database object.
			--   @param srcary an array of the source detabase objects.
			--   @param srcnum the number of the elements of the source array.
			--   @param mode the merge mode.  KCMSET to overwrite the existing value, KCMADD to keep the
			--   existing value, KCMREPLACE to modify the existing record only, KCMAPPEND to append the new
			--   value.
			--   @return true on success, or false on failure.
 		external "C"
		alias "kcdbmerge"
		end

	kc_dbcursor (a_db_ptr: POINTER): POINTER
			--   Create a cursor object.
			--   @param db a database object.
			--   @return the return value is the created cursor object.
			--   @note The object of the return value should be released with the kccurdel function when it is
			--   no longer in use.
 		external "C"
		alias "kcdbcursor"
		end

	kc_curdel (a_cur: POINTER)
			--   Destroy a cursor object.
			--   @param cur the cursor object.
 		external "C"
		alias "kccurdel"
		end

	kc_curaccept (a_cur: POINTER; a_fullproc: POINTER; a_opq: POINTER; a_writable: INTEGER_32; a_step: INTEGER_32): INTEGER_32
			--   Accept a visitor to the current record.
			--   @param cur a cursor object.
			--   @param fullproc a call back function to visit a record.
			--   @param opq an opaque pointer to be given to the call back functions.
			--   @param writable true for writable operation, or false for read-only operation.
			--   @param step true to move the cursor to the next record, or false for no move.
			--   @return true on success, or false on failure.
 		external "C"
		alias "kccuraccept"
		end

	kc_cursetvalue (a_cur: POINTER; a_vbuf: POINTER; a_vsiz: INTEGER_64; a_step: INTEGER_32): INTEGER_32
			--   Set the value of the current record.
			--   @param cur a cursor object.
			--   @param vbuf the pointer to the value region.
			--   @param vsiz the size of the value region.
			--   @param step true to move the cursor to the next record, or false for no move.
			--   @return true on success, or false on failure.
 		external "C"
		alias "kccursetvalue"
		end

	kc_curremove (a_cur: POINTER): INTEGER_32
			--   Remove the current record.
			--   @param cur a cursor object.
			--   @return true on success, or false on failure.
			--   @note If no record corresponds to the key, false is returned.  The cursor is moved to the
			--   next record implicitly.
 		external "C"
		alias "kccurremove"
		end

	kc_curgetkey (a_cur: POINTER; a_sp: POINTER; a_step: INTEGER_32): POINTER
			--   Get the key of the current record.
			--   @param cur a cursor object.
			--   @param sp the pointer to the variable into which the size of the region of the return value
			--   is assigned.
			--   @param step true to move the cursor to the next record, or false for no move.
			--   @return the pointer to the key region of the current record, or NULL on failure.
			--   @note If the cursor is invalidated, NULL is returned.  Because an additional zero
			--   code is appended at the end of the region of the return value, the return value can be
			--   treated as a C-style string.  The region of the return value should be released with the
			--   kcfree function when it is no longer in use.
 		external "C"
		alias "kccurgetkey"
		end

	kc_curgetvalue (a_cur: POINTER; a_sp: POINTER; a_step: INTEGER_32): POINTER
			--   Get the value of the current record.
			--   @param cur a cursor object.
			--   @param sp the pointer to the variable into which the size of the region of the return value
			--   is assigned.
			--   @param step true to move the cursor to the next record, or false for no move.
			--   @return the pointer to the value region of the current record, or NULL on failure.
			--   @note If the cursor is invalidated, NULL is returned.  Because an additional zero
			--   code is appended at the end of the region of the return value, the return value can be
			--   treated as a C-style string.  The region of the return value should be released with the
			--   kcfree function when it is no longer in use.
 		external "C"
		alias "kccurgetvalue"
		end

	kc_curget (KCCUR* a_cur: POINTER; a_ksp: INTEGER_64; a_vbp: POINTER; a_vsp: POINTER; a_step: INTEGER_32): POINTER
			--   Get a pair of the key and the value of the current record.
			--   @param cur a cursor object.
			--   @param ksp the pointer to the variable into which the size of the region of the return
			--   value is assigned.
			--   @param vbp the pointer to the variable into which the pointer to the value region is
			--   assigned.
			--   @param vsp the pointer to the variable into which the size of the value region is
			--   assigned.
			--   @param step true to move the cursor to the next record, or false for no move.
			--   @return the pointer to the pair of the key region, or NULL on failure.
			--   @note If the cursor is invalidated, NULL is returned.  Because an additional zero code is
			--   appended at the end of each region of the key and the value, each region can be treated
			--   as a C-style string.  The region of the return value should be released with the kcfree
			--   function when it is no longer in use.
 		external "C"
		alias "kccurget"
		end

	kc_curjump (a_cur: POINTER): INTEGER_32
			--   Jump the cursor to the first record for forward scan.
			--   @param cur a cursor object.
			--   @return true on success, or false on failure.
 		external "C"
		alias "kccurjump"
		end

	kc_curjumpkey (a_cur: POINTER; a_kbuf: POINTER, a_ksiz: INTEGER_64): INTEGER_32
			--   Jump the cursor to a record for forward scan.
			--   @param cur a cursor object.
			--   @param kbuf the pointer to the key region.
			--   @param ksiz the size of the key region.
			--   @return true on success, or false on failure.
 		external "C"
		alias "kccurjumpkey"
		end

	kc_curjumpback(a_cur: POINTER): INTEGER_32
			--   Jump the cursor to the last record for backward scan.
			--   @param cur a cursor object.
			--   @return true on success, or false on failure.
			--   @note This method is dedicated to tree databases.  Some database types, especially hash
			--   databases, may provide a dummy implementation.
 		external "C"
		alias "kccurjumpback"
		end

	kc_curjumpbackkey (a_cur: POINTER; a_kbuf: POINTER, a_ksiz: INTEGER_64): INTEGER_32
			--   Jump the cursor to a record for backward scan.
			--   @param cur a cursor object.
			--   @param kbuf the pointer to the key region.
			--   @param ksiz the size of the key region.
			--   @return true on success, or false on failure.
			--   @note This method is dedicated to tree databases.  Some database types, especially hash
			--   databases, will provide a dummy implementation.
 		external "C"
		alias "kccurjumpbackkey"
		end

	kc_curstep (a_cur: POINTER): INTEGER_32
			--   Step the cursor to the next record.
			--   @param cur a cursor object.
			--   @return true on success, or false on failure.
 		external "C"
		alias "kccurstep"
		end

	kc_curstepback (a_cur: POINTER): INTEGER_32
			--   Step the cursor to the previous record.
			--   @param cur a cursor object.
			--   @return true on success, or false on failure.
			--   @note This method is dedicated to tree databases.  Some database types, especially hash
			--   databases, may provide a dummy implementation.
 		external "C"
		alias "kccurstepback"
		end

	kc_curdb (a_cur: POINTER): POINTER
			--   Get the database object.
			--   @param cur a cursor object.
			--   @return the database object.
 		external "C"
		alias "kccurdb"
		end

	kc_curecode (a_cur: POINTER): INTEGER_32
			--   Get the code of the last happened error.
			--   @param cur a cursor object.
			--   @return the code of the last happened error.
 		external "C"
		alias "kccurecode"
		end

	kc_curemsg (a_cur: POINTER): POINTER
			--   Get the supplement message of the last happened error.
			--   @param cur a cursor object.
			--   @return the supplement message of the last happened error.
 		external "C"
		alias "kccuremsg"
		end

end -- class EKC_EXTERNALS

