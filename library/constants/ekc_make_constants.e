indexing

	description: "Generate class for KyotoCabinet constants"

class EKC_MAKE_CONSTANTS

inherit

	MAKE_CONSTANTS_FROM_C

create

	make

feature

	make is
		do
			set_class_name ("EKC_CONSTANTS")

			include ("/data/Master/dbms/kyotocabinet/kyotocabinet-1.2.24/kclangc.h")
			
			append_head
			process_features
			append_tail
		end

	process_features
		do
				-- Error codes:
			insert_comment ("Error codes:")
			process_integer_feature_as ("KCESUCCESS",	"Kce_success")	-- Success
			process_integer_feature_as ("KCENOIMPL", 	"Kce_noimpl")	-- Not Implemented
			process_integer_feature_as ("KCEINVALID",	"Kce_invalid")	-- Invalid operation
			process_integer_feature_as ("KCENOREPOS",	"Kce_norepos")	-- No repository
			process_integer_feature_as ("KCENOPERM",	"Kce_noperm")	-- No permission
			process_integer_feature_as ("KCEBROKEN", 	"Kce_broken")	-- Broken file
			process_integer_feature_as ("KCEDUPREC", 	"Kce_duprec")	-- Record duplication
			process_integer_feature_as ("KCENOREC", 	"Kce_norec")	-- No record
			process_integer_feature_as ("KCELOGIC", 	"Kce_logic")	-- Logical inconsistency
			process_integer_feature_as ("KCESYSTEM", 	"Kce_system")	-- System error
			process_integer_feature_as ("KCEMISC",		"Kce_misc")		-- Miscellaneous error

				-- Open modes:
			insert_comment ("Open modes:")
			process_integer_feature_as ("KCOREADER", 	"Kco_reader")	-- Open as a reader
			process_integer_feature_as ("KCOWRITER", 	"Kco_writer")	-- Open as a writer
			process_integer_feature_as ("KCOCREATE", 	"Kco_create")	-- Writer creating
			process_integer_feature_as ("KCOTRUNCATE", 	"Kco_truncate")	-- Writer truncating
			process_integer_feature_as ("KCOAUTOTRAN", 	"Kco_autotran")	-- Auto transaction
			process_integer_feature_as ("KCOAUTOSYNC", 	"Kco_autosync")	-- Auto synchronization
			process_integer_feature_as ("KCONOLOCK", 	"Kco_nolock")	-- Open without locking
			process_integer_feature_as ("KCOTRYLOCK", 	"Kco_trylock")	-- Lock without blocking
			process_integer_feature_as ("KCONOREPAIR", 	"Kco_norepair")	-- Open without auto-repair

				-- Merge modes:
			insert_comment ("Merge modes:")
			process_integer_feature_as ("KCMSET", 		"Kcm_set")		-- Overwrite existing value
			process_integer_feature_as ("KCMADD", 		"Kcm_add")		-- Keep the existing value
			process_integer_feature_as ("KCMREPLACE", 	"Kcm_replace")	-- Modify the existing record only
			process_integer_feature_as ("KCMAPPEND", 	"Kcm_append")		-- Append the new value
		end

end