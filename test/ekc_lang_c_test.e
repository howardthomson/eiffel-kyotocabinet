note

		description: "Transliteration of 'kclangctest' from the KyotoCabinet package"

	header_text: "[

			/*************************************************************************************************
			 * The test cases of the C language binding
			 *                                                               Copyright (C) 2009-2010 FAL Labs
			 * This file is part of Kyoto Cabinet.
			 * This program is free software: you can redistribute it and/or modify it under the terms of
			 * the GNU General Public License as published by the Free Software Foundation, either version
			 * 3 of the License, or any later version.
			 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
			 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			 * See the GNU General Public License for more details.
			 * You should have received a copy of the GNU General Public License along with this program.
			 * If not, see <http://www.gnu.org/licenses/>.
			 *************************************************************************************************/
	]"

	Typedefs: "[

			typedef struct {                         /* arguments of visitor */
			  int64_t rnum;
			  int32_t rnd;
			  int64_t cnt;
			  char rbuf[RECBUFSIZ];
			} VISARG;
	]"


	Function_prototypes: "[

			static int64_t myrand(int64_t range);
			static void iprintf(const char* format, ...);
			static void iputchar(char c);
			static void eprintf(const char* format, ...);
			static void dberrprint(KCDB* db, int32_t line, const char* func);
			const char* visitfull(const char* kbuf, size_t ksiz,
			                      const char* vbuf, size_t vsiz, size_t* sp, void* opq);
			static int32_t procorder(const char* path, int64_t rnum, int32_t rnd, int32_t etc,
			                         int32_t tran, int32_t oflags);
	]"

class EKC_LANG_C_TEST

inherit

	EKC_EXTERNALS
	KL_SHARED_ARGUMENTS
	KL_SHARED_EXCEPTIONS

create

	make

feature -- Constants

	I_false: INTEGER_32 = 0
	I_true:  INTEGER_32 = 1

	C__LINE__: Integer = 0
			-- Temp substitute for __LINE__ C/C++ special value

feature -- Attributes

	RECBUFSIZ:  INTEGER =    64		-- buffer size for a record
	RECBUFSIZL: INTEGER =   1024	-- buffer size for a long record

	g_progname: STRING              
			-- program name */

	random: RANDOM

feature -- Creation

	make
			-- System entry point
		local
			i, rv: INTEGER_32
		do
			g_progname := Arguments.argument (0)
			create random.make
--#			random.set_seed (time (NULL))
			if Arguments.argument_count < 2 then
				usage
			end
			if Arguments.argument (1).is_equal ("order") then
				rv := runorder
			else
				usage
			end
			if rv /= 0 then
				print ("FAILED:")
				from i := 1 until i > Arguments.argument_count loop
					print (once " ")
					print (Arguments.argument (i))
					i := i + 1
				end
				print ("%N%N")
			end
			Exceptions.die (rv)
		end

	usage
			-- print the usage and exit
		do
			print (g_progname)
			print (": test cases of the C binding of Kyoto Cabinet%N%N")
			print ("usage:%N  ")
			print (g_progname)
			print (" order [-rnd] [-etc] [-tran] [-oat|-oas|-onl|-otl|-onr] path rnum%N")
			print ("%N")
			Exceptions.die (1)	--	  exit(1);
		end



--	/* print formatted error string and flush the buffer */
--	static void iprintf(const char* format, ...) {
--	  va_list ap;
--	  va_start(ap, format);
--	  vprintf(format, ap);
--	  va_end(ap);
--	  fflush(stdout);
--	}

	iputchar (c: CHARACTER)
			--	print a character and flush the buffer
		do
			io.output.putchar (c)
			io.output.flush
		end

	eprintf (a_format: STRING; a_args: TUPLE)
			--	print formatted error string and flush the buffer
			--	static void eprintf(const char* format, ...) {
		do
			--	  va_list ap;
			--	  va_start(ap, format);
			--	  vfprintf(stderr, format, ap);
			--	  va_end(ap);
			io.stderr.flush		--	  fflush(stderr);
		end

	dberrprint (db: POINTER; line: INTEGER_32; func: STRING)
			--	print error message of database
			--	static void dberrprint(KCDB* db, int32_t line, const char* func) {
		local
			path: STRING
				--	  char* path;
			emsg: STRING
				--	  const char* emsg;
			c_path, c_emsg: POINTER
				-- C char * ...

			ecode: INTEGER_32
				--	  int32_t ecode;
			l_colon_space: STRING
		do
			l_colon_space := once ": "
			c_path := kc_dbpath (db)
			c_emsg := kc_dbemsg (db)
			ecode := kc_dbecode (db)
				--	  iprintf("%s: %d: %s: %s: %d: %s: %s%N",
				--	          g_progname, line, func, path ? path : "-", ecode, kc_ecodename(ecode), emsg);
			print (g_progname); print (l_colon_space)
		--	print (line.out); print (l_colon_space)
			if func /= Void then
				print (func); print (l_colon_space)
			else
				print (once "-"); print (l_colon_space)
			end
		--	print (ecode.out); XXXX
		--	print (kc_ecodename(ecode) ...
		--	print (emsg ....
			
			kc_free (c_path)
		end

	dbmetaprint (db: POINTER; a_verbose: BOOLEAN)
			-- print members of database
		local
			p_status: POINTER
			rp: POINTER
				--	char* status, *rp;
		do
			if a_verbose then
			    p_status := kc_dbstatus (db)
			    if p_status /= default_pointer then
--					rp = status;
--					while (*rp != '\0') {
--						if (*rp == '\t') then
--							printf(": ");
--						else
--							putchar(*rp);
--						end
--						rp++;
--					end
					kc_free (p_status)
				end
			else
				print ("count: "); print (kc_dbcount (db).out); print ("%N")
				print ("size: " ); print (kc_dbsize  (db).out); print ("%N")
			end
		end


--	/* visit a full record */
--	const char* visitfull(const char* kbuf, size_t ksiz,
--	                      const char* vbuf, size_t vsiz, size_t* sp, void* opq) {
--	  VISARG* arg;
--	  const char* rv;
--	  arg = opq;
--	  arg->cnt++;
--	  rv = KCVISNOP;
--	  switch (arg->rnd ? myrand(7) : arg->cnt % 7) {
--	    case 0: {
--	      rv = arg->rbuf;
--	      *sp = arg->rnd ? myrand(sizeof(arg->rbuf)) : sizeof(arg->rbuf) / (arg->cnt % 5 + 1);
--	      break;
--	    }
--	    case 1: {
--	      rv = KCVISREMOVE;
--	      break;
--	    }
--	  }
--	  if (arg->rnum > 250 && arg->cnt % (arg->rnum / 250) == 0) {
--	    iputchar('.');
--	    if (arg->cnt == arg->rnum || arg->cnt % (arg->rnum / 10) == 0)
--	      iprintf(" (%08ld)%N", (long)arg->cnt);
--	  }
--	  return rv;
--	}

feature {NONE} -- Implementation ...

	runorder: INTEGER_32
			--	parse arguments of order command
			--	static int32_t runorder(int argc, char** argv) {
		local
			argbrk: BOOLEAN
				--	  int32_t argbrk = I_false;
			path, rstr: STRING
				--	  const char* path, *rstr;
			rnd, etc, tran: BOOLEAN
				--	  int32_t rnd, etc, tran;
			i, mode, oflags, rnum: INTEGER_32
				--	  int32_t i, mode, oflags, rnum;
		do
			from i := 2 until i > Arguments.argument_count loop
				if not argbrk and then Arguments.argument (i).item (1) = '-' then
					if Arguments.argument (i).is_equal ("--") then
						argbrk := True
					elseif Arguments.argument (i).is_equal ("-rnd") then
				        rnd := True
				    elseif Arguments.argument (i).is_equal ("-etc") then
				        etc := True
				    elseif Arguments.argument (i).is_equal ("-tran") then
				        tran := True
				    elseif Arguments.argument (i).is_equal ("-oat") then
				        oflags := oflags | KCO_AUTOTRAN
				    elseif Arguments.argument (i).is_equal ("-oas") then
				        oflags := oflags | KCO_AUTOSYNC
				    elseif Arguments.argument (i).is_equal ("-onl") then
				        oflags := oflags | KCO_NOLOCK
				    elseif Arguments.argument (i).is_equal ("-otl") then
				        oflags := oflags | KCO_TRYLOCK
				    elseif Arguments.argument (i).is_equal ("-onr") then
				        oflags := oflags | KCO_NOREPAIR
				    else
				        usage
				    end
			    elseif path = Void then
					argbrk := True
					path := Arguments.argument (i)
				elseif rstr = Void then
					rstr := Arguments.argument (i)
				else
					usage
				end
				i := i + 1
			end
			if path = Void or else rstr = Void then
				usage
			end
			rnum := rstr.to_integer	-- atoi(rstr)
			if rnum < 1 then usage end
			Result := procorder (path, rnum, rnd, etc, tran, oflags)
		end

	to_c_string (a_string: STRING): POINTER
		do
		end

	procorder (path: STRING; rnum: INTEGER_64; rnd: BOOLEAN; etc: BOOLEAN; tran: BOOLEAN; oflags: INTEGER_32): INTEGER_32

		local
			db: POINTER
				--	  KCDB* db;
				
			cur, paracur: POINTER
				--	  KCCUR* cur, *paracur;

			err: BOOLEAN	
				--	  int32_t err;

			
			vbuf, corepath, copypath, snappath: POINTER
				--	  char *vbuf, *corepath, *copypath, *snappath;

			kbuf, wbuf: MANAGED_POINTER
				--	  char kbuf[RECBUFSIZ], wbuf[RECBUFSIZ];

			ksiz, vsiz, psiz: INTEGER_64
				--	  size_t ksiz, vsiz, psiz;

			wsiz: INTEGER_32
				--	  int32_t wsiz;

			i, cnt: INTEGER_64
				--	  int64_t i, cnt;

			stime, etime: REAL_64
				--	  double stime, etime;
	
				--	  VISARG visarg;

		do

--			iprintf("<In-order Test>%N  path=%s  rnum=%ld  rnd=%d  etc=%d  tran=%d  oflags=%d%N%N",
--				[path, rnum, rnd, etc, tran, oflags])

			db := kc_dbnew
			print ("opening the database:%N")
			stime := kc_time
			if 0 = kc_dbopen (db, to_c_string (path), KCO_WRITER | KCO_CREATE | KCO_TRUNCATE | oflags) then
--				dberrprint (db, C__LINE__, "kc_dbopen")
				err := True
			end
			etime := kc_time
--			dbmetaprint (db, False)
--			iprintf ("time: %.3f%N", etime - stime)
			print ("setting records:%N")
			stime := kc_time
				-- for (i = 1; !err && i <= rnum; i++) {
			from i := 1 until (err or else i > rnum) loop
				if tran and then 0 = kc_dbbegintran (db, I_false) then
--	      			dberrprint (db, C__LINE__, "kc_dbbegintran");
	      			err := True
	    		end
--	    		ksiz := sprintf(kbuf, "%08ld", (long)(rnd ? myrand(rnum) + 1 : i));
--	    		if 0 = kc_dbset (db, kbuf, ksiz, kbuf, ksiz) then
--	      			dberrprint (db, C__LINE__, "kc_dbset");
	      			err := True
--	    		end
	    		if tran and then 0 = kc_dbendtran (db, I_true) then
--	      			dberrprint (db, C__LINE__, "kc_dbendtran");
	      			err := True
	    		end
    			if rnum > 250 and then i \\ (rnum // 250) = 0 then
	      			iputchar ('.')
	      			if i = rnum or else i \\ (rnum // 10) = 0 then
--						iprintf(" (%08ld)%N", (long)i)
					end
	    		end
				i := i + 1
	  		end				
			etime := kc_time
			dbmetaprint (db, False)			
--			iprintf ("time: %.3f%N", etime - stime);
			if etc then
				print ("adding records:%N")
				stime := kc_time
					--	for (i = 1; !err && i <= rnum; i++) {
				from i := 1 until err or else i > rnum loop
				
					if tran and then 0 = kc_dbbegintran (db, I_false) then
						dberrprint (db, C__LINE__, "kcdbbegintran")
						err := True
					end
--					ksiz = sprintf (kbuf, "%08ld", (long)(rnd ? myrand(rnum) + 1 : i));
--					if 0 = kc_dbadd (db, kbuf, ksiz, kbuf, ksiz) and then kc_dbecode (db) /= KCEDUPREC then
						dberrprint (db, C__LINE__, "kcdbadd")
						err := True
--					end
					if tran and then 0 = kc_dbendtran (db, I_true) then
						dberrprint(db, C__LINE__, "kcdbendtran");
						err := True
					end
					if rnum > 250 and then i \\ (rnum // 250) = 0 then
						iputchar('.')
						if i = rnum or else i \\ (rnum // 10) = 0 then
--							iprintf(" (%08ld)%N", (long)i)
						end
					end
				end
				etime := kc_time
				dbmetaprint (db, False)
--				iprintf("time: %.3f%N", etime - stime)
			end


				
			if etc then
				print ("appending records:%N")
				stime := kc_time
					-- for (i = 1; !err && i <= rnum; i++) {
				from i := 1 until err or else i > rnum loop
					if tran and then 0 = kc_dbbegintran (db, I_false) then
						dberrprint (db, C__LINE__, "kcdbbegintran")
						err := True
					end
--					ksiz = sprintf(kbuf, "%08ld", (long)(rnd ? myrand(rnum) + 1 : i));
--					if 0 = kc_dbappend (db, kbuf, ksiz, kbuf, ksiz) then
						dberrprint (db, C__LINE__, "kcdbadd")
						err := True
--					end
					if tran and then 0 = kc_dbendtran (db, I_true) then
						dberrprint (db, C__LINE__, "kcdbendtran")
						err := True
					end
					if rnum > 250 and then i \\ (rnum // 250) = 0 then
						iputchar('.')
						if i = rnum or else i \\ (rnum // 10) = 0 then
--							iprintf(" (%08ld)%N", (long)i)
						end
					end
					i := i + 1
				end
				etime := kc_time
				dbmetaprint (db, False)
--				iprintf("time: %.3f%N", etime - stime);
			end


			
			print ("getting records:%N")
			stime := kc_time
				-- for (i = 1; !err && i <= rnum; i++) {
			from i := 1 until err or else i > rnum loop
				if tran and then 0 = kc_dbbegintran (db, I_false) then
					dberrprint (db, C__LINE__, "kcdbbegintran")
					err := True
				end
--				ksiz := sprintf (kbuf, "%08ld", (long)(rnd ? myrand(rnum) + 1 : i));
			--	vbuf := kc_dbget (db, kbuf, ksiz, &vsiz)
				if vbuf /= Void then
			--		if vsiz < ksiz or else memcmp (vbuf, kbuf, ksiz) then
						dberrprint (db, C__LINE__, "kcdbget")
						err := True
			--		end
					kc_free (vbuf)
				elseif not rnd or else kc_dbecode (db) /= KCE_NOREC then
					dberrprint(db, C__LINE__, "kcdbget")
					err := True
				end
				if tran and then 0 = kc_dbendtran (db, I_true) then
					dberrprint (db, C__LINE__, "kcdbendtran")
					err := True
				end
				if rnum > 250 and then i \\ (rnum // 250) = 0 then
					iputchar('.');
					if i = rnum or else i \\ (rnum // 10) = 0 then
--						iprintf(" (%08ld)%N", (long)i);
					end
				end
				i := i + 1
			end

			etime := kc_time
			dbmetaprint (db, False)
				--	  iprintf("time: %.3f%N", etime - stime);
				--	  if etc then
				--	    print ("getting records with a buffer:%N");
				--	    stime := kc_time
				--		from i := 1 until err or else i > rnum loop
				--	    				for (i = 1; !err && i <= rnum; i++) {
				--	      if tran and then 0 = kc_dbbegintran (db, I_false) then
				--	        dberrprint(db, C__LINE__, "kcdbbegintran")
				--	        err := True
				--	      end
				--	      ksiz := sprintf(kbuf, "%08ld", (long)(rnd ? myrand(rnum) + 1 : i))
				--	      wsiz := kc_dbgetbuf (db, kbuf, ksiz, wbuf, sizeof(wbuf))
				--	      if wsiz >= 0 then
				--	        if (wsiz < (int32_t)ksiz || memcmp(wbuf, kbuf, ksiz)) then
				--	          dberrprint(db, C__LINE__, "kcdbgetbuf")
				--	          err := True
				--	        end
				--	      elseif (not rnd or else kc_dbecode (db) != KCE_NOREC then
				--	        dberrprint(db, C__LINE__, "kcdbgetbuf")
				--	        err := True
				--	      end
				--	      if tran and then 0 = kc_dbendtran (db, I_true) then
				--	        dberrprint(db, C__LINE__, "kcdbendtran")
				--	        err := True
				--	      end
				--	      if rnum > 250 and then i \\ (rnum // 250) = 0 then
				--	        iputchar('.')
				--	        if i = rnum or else i \\ (rnum // 10) = 0 then iprintf(" (%08ld)%N", (long)i) end
				--	      end
				--	    end
				--	    etime := kc_time
				--	    dbmetaprint (db, False)
				--	    iprintf("time: %.3f%N", etime - stime)
				--	  end
				--	  if etc then
				--	    print ("traversing the database by the inner iterator:%N");
				--	    stime := kc_time
				--	    cnt := kc_dbcount (db)
				--	    visarg.rnum := rnum;
				--	    visarg.rnd := rnd;
				--	    visarg.cnt := 0;
				--	    memset(visarg.rbuf, '+', sizeof(visarg.rbuf));
				--	    if tran and then 0 = kc_dbbegintran (db, I_false) then
				--	      dberrprint(db, C__LINE__, "kcdbbegintran")
				--	      err := True
				--	    end
				--	    if 0 = kc_dbiterate (db, visitfull, &visarg, I_true) then
				--	      dberrprint(db, C__LINE__, "kcdbiterate")
				--	      err := True
				--	    end
				--	    if rnd then print (" (end)%N") end
				--	    if tran and then 0 = kc_dbendtran (db, I_true) then
				--	      dberrprint(db, C__LINE__, "kcdbendtran")
				--	      err := True
				--	    end
				--	    if visarg.cnt /= cnt then
				--	      dberrprint(db, C__LINE__, "kcdbiterate")
				--	      err := True
				--	    end
				--	    etime := kc_time
				--	    dbmetaprint(db, False)
				--	    iprintf("time: %.3f%N", etime - stime);
				--	  end
				--	  if etc then
				--	    print ("traversing the database by the outer cursor:%N");
				--	    stime := kc_time
				--	    cnt := kc_dbcount (db)
				--	    visarg.rnum := rnum
				--	    visarg.rnd := rnd
				--	    visarg.cnt := 0
				--	    if tran and then 0 = kc_dbbegintran (db, I_false) then
				--	      dberrprint(db, C__LINE__, "kcdbbegintran")
				--	      err := True
				--	    end
				--	    cur := kc_dbcursor (db)
				--	    if 0 = kc_curjump (cur) and then kc_curecode (cur) != KCE_NOREC then
				--	      dberrprint(db, C__LINE__, "kccurjump")
				--	      err := True
				--	    end
				--	    paracur := kc_dbcursor (db)
--#				--	    while (!err && kc_curaccept(cur, &visitfull, &visarg, I_true, !rnd)) {
				--	      if rnd then
				--	        ksiz := sprintf(kbuf, "%08ld", (long)myrand(rnum))
				--	        switch (myrand(3)) {
				--	          case 0: {
				--	            if 0 = kc_dbremove (db, kbuf, ksiz) and then kc_dbecode (db) /= KCE_NOREC then
				--	              dberrprint(db, C__LINE__, "kcdbremove")
				--	              err := True
				--	            end
				--	            break; ##################
				--	          end
				--	          case 1: { 
				--	            if 0 = kc_curjumpkey (paracur, kbuf, ksiz) and then kc_curecode (paracur) /= KCE_NOREC then
				--	              dberrprint(db, C__LINE__, "kccurjump");
				--	              err := True
				--	            }
				--	            break; ###############################
				--	          }
				--	          default: {
				--	            if 0 = kc_curstep (cur) and then kc_curecode (cur) /= KCE_NOREC then
				--	              dberrprint (db, C__LINE__, "kccurstep");
				--	              err := True
				--	            }
				--	            break; #######################################################
				--	          end
				--	        end
				--	      end
				--	    end
				--	    print (" (end)%N")
				--	    kc_curdel (paracur)
				--	    kc_curdel (cur)
				--	    if tran and then 0 = kc_dbendtran (db, I_true) then
				--	      dberrprint(db, C__LINE__, "kcdbendtran");
				--	      err := True
				--	    end
				--	    if not rnd and then visarg.cnt /= cnt then
				--	      dberrprint(db, C__LINE__, "kccuraccept")
				--	      err := True
				--	    end
				--	    etime = kc_time();
				--	    dbmetaprint(db, False);
				--	    iprintf("time: %.3f%N", etime - stime);
				--	  end
				--	  if etc then
				--	    print ("synchronizing the database:%N");
				--	    stime := kc_time
				--	    if 0 = kc_dbsync (db, I_false, NULL, NULL) then
				--	      dberrprint(db, C__LINE__, "kcdbsync")
				--	      err := True
				--	    end
				--	    etime = kc_time();
				--	    dbmetaprint(db, False);
				--	    iprintf("time: %.3f%N", etime - stime);
				--	  end
				--	  if etc then
				--	    corepath = kc_dbpath (db)
				--	    psiz = strlen (corepath)
				--	    if (strstr(corepath, ".kch") || strstr(corepath, ".kct") then
				--	      copypath = kc_malloc(psiz + 256)
				--	      sprintf(copypath, "%s.tmp", corepath)
				--	      snappath = kc_malloc(psiz + 256)
				--	      sprintf(snappath, "%s.kcss", corepath)
				--	    else
				--	      copypath := kc_malloc (256)
				--	      sprintf (copypath, "kclangctest.tmp")
				--	      snappath := kc_malloc (256)
				--	      sprintf(snappath, "kclangctest.kcss")
				--	    end
				--	    print ("copying the database file:%N");
				--	    stime := kc_time
				--	    if 0 = kc_dbcopy (db, copypath) then
				--	      dberrprint(db, C__LINE__, "kcdbcopy");
				--	      err := True
				--	    end
				--	    etime := kc_time
				--	    dbmetaprint (db, False)
				--	    iprintf("time: %.3f%N", etime - stime);
				--	    remove (copypath)
				--	    print ("dumping records into snapshot:%N");
				--	    stime := kc_time
				--	    if 0 = kc_dbdumpsnap (db, snappath) then
				--	      dberrprint(db, C__LINE__, "kcdbdumpsnap");
				--	      err := True
				--	    end
				--	    etime := kc_time
				--	    dbmetaprint (db, False)
				--	    iprintf("time: %.3f%N", etime - stime)
				--	    print ("loading records into snapshot:%N")
				--	    stime := kc_time
				--	    cnt := kc_dbcount (db)
				--	    if rnd and then myrand (2) = 0 and then 0 = kc_dbclear (db) then
				--	      dberrprint(db, C__LINE__, "kcdbclear");
				--	      err := True
				--	    end
				--	    if 0 = kc_dbloadsnap (db, snappath) or else kc_dbcount (db) /= cnt then
				--	      dberrprint(db, C__LINE__, "kcdbloadsnap")
				--	      err := True
				--	    end
				--	    etime := kc_time
				--	    dbmetaprint (db, False)
				--	    iprintf("time: %.3f%N", etime - stime);
				--	    remove (snappath)
				--	    kc_free (copypath)
				--	    kc_free (snappath)
				--	    kc_free (corepath)
				--	  end
				--	  print ("removing records:%N");
				--	  stime := kc_time
				--		from i := 1 until err or else i > rnum loop
				--	  					for (i = 1; !err && i <= rnum; i++) 
				--	    if tran and then 0 = kc_dbbegintran (db, I_false) then
				--	      dberrprint (db, C__LINE__, "kcdbbegintran")
				--	      err := True
				--	    }
				--	    ksiz = sprintf(kbuf, "%08ld", (long)(rnd ? myrand(rnum) + 1 : i));
				--	    if 0 = kc_dbremove (db, kbuf, ksiz) and then
				--	        ((not rnd and then notetc) or else kc_dbecode (db) != KCE_NOREC) then
				--	      dberrprint (db, C__LINE__, "kcdbremove")
				--	      err := True
				--	    end
				--	    if tran and then 0 = kc_dbendtran (db, I_true) then
				--	      dberrprint(db, C__LINE__, "kcdbendtran");
				--	      err := True
				--	    end
				--	    if rnum > 250 and then i \\ (rnum // 250) = 0 then
				--	      iputchar('.');
				--	      if i = rnum or else i \\ (rnum // 10) = 0 then iprintf(" (%08ld)%N", (long)i) end
				--	    }
						i := i + 1
				--	  end
				--	  etime := kc_time
				--	  dbmetaprint (db, I_true);
				--	  iprintf("time: %.3f%N", etime - stime)
				--	  print ("closing the database:%N")
				--	  stime := kc_time
				--	  if 0 /= kc_dbclose (db) then
				--	    dberrprint (db, C__LINE__, "kcdbclose")
				--	    err := True
				--	  end
				--	  etime := kc_time
				--	  iprintf("time: %.3f%N", etime - stime);
				--	  iprintf("%s%N%N", err ? "error" : "ok");
				--	  kc_dbdel (db)
				--	  return err ? 1 : 0;
		end

feature -- Implementation


	myrand (range: INTEGER_64): INTEGER_64
			-- get a random number, specific to this implementation
		local
			base, mask: NATURAL_64;
		do
			if range < 2 then
				Result := 0
			else
--				base := range * (rand() / (RAND_MAX + 1.0))
--				mask := (uint64_t)rand() << 30
--				mask := mask + (uint64_t)rand() >> 2
--				Result := (base ^ mask) % range
			end
		end


--	/* END OF FILE */

end
