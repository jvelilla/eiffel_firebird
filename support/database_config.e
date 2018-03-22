note
	description: "Summary description for {DATABASE_CONFIG}."
	date: "$Date: 2017-02-01 11:21:00 -0300 (mi. 01 de feb. de 2017) $"
	revision: "$Revision: 99782 $"

deferred class
	DATABASE_CONFIG

feature -- Database access

	default_hostname: STRING = ""
			-- Database hostname.

	default_username: STRING = ""
			-- Database username.

	default_password: STRING = ""
			-- Database password.

	default_database_name: STRING = "EiffelDB"
			-- Database name.

	is_keep_connection: BOOLEAN
			-- Keep Connection to database?
		do
			Result := True
		end

end
