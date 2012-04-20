note

	description: "Base class for generating constants from a C header file ..."

deferred class MAKE_CONSTANTS_FROM_C

feature -- Generic code, to be factored out ....

	class_name: STRING
	file_name: STRING

	out_file: TEXT_FILE_WRITE
	
	set_class_name (a_name: STRING) is
			-- Initialize, based on class name
		require
			valid_class_name: a_name /= Void
		do
			class_name := a_name
			file_name := "make_" + class_name.as_lower + ".c"
			create out_file.connect_to(file_name)
		--	if not out_file.is_connected then
		--		die
		--	end
		end

	include (s: STRING) is
			-- append an #include directive
		require
			non_void_filename: s /= Void
		do
			out_file.put_string("#include %"")
			out_file.put_string(s)
			out_file.put_string("%"%N%N")
		end

	append_head is
			-- boiler-plate code for data declarations
			-- and start of 'main' routine
		require
			class_name_set: class_name /= Void
		do
			out_file.put_string("[
				char *class_head =
					"class %s\n"
					"\n"
					"feature\n"
					"\n";

				char *class_tail =
					"end\n";


			]")
			out_file.put_string("char *class_name = %"")
			out_file.put_string(class_name)
			out_file.put_string("%";%N%N")
			out_file.put_string("[
				int main(int ac, char **av) {

					printf(class_head, class_name);

			]")
		end

	insert_comment (a_comment: STRING)
		require
			valid_comment: a_comment /= Void
		do
			out_file.put_string ("%Tprintf(%"\t\t-- ")
			out_file.put_string (a_comment)
			out_file.put_string ("\n%");")
		end

	process_integer_feature (s: STRING)
		require
			valid_feature_name: s /= Void
		do
			process_integer_feature_as (s, s)
		end

	process_integer_feature_as (s1, s2: STRING)
		require
			valid_constant_name: s1 /= Void
			valid_feature_name: s2 /= Void
		do
			out_file.put_string("%Tprintf(%"\t")
			out_file.put_string(s2)
			out_file.put_string(": INTEGER is %%d\n%", ")
			out_file.put_string(s1)
			out_file.put_string(");%N")
		end

	process_hexadecimal_feature (s: STRING)
		require
			valid_feature_name: s /= Void
		do
			out_file.put_string("%Tprintf(%"\t")
			out_file.put_string(s)
			out_file.put_string(": INTEGER is 0x%%.8x\n%", ")
			out_file.put_string(s)
			out_file.put_string(");%N")
		end

	append_tail is
			-- Append tail and close output file
		do
			out_file.put_string("%Tprintf(class_tail);%N")
			out_file.put_string("}%N")
			out_file.disconnect
		end


end -- class MAKE_CONSTANTS_FROM_C
