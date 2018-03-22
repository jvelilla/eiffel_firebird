note
	description: "Simple example test EiffelStore with Firebird database using ODBC"
	date: "$Date: 2018-01-25 09:41:02 -0300 (ju. 25 de ene. de 2018) $"
	revision: "$Revision: 101300 $"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			do
				test_select_employee_by_job_code
			end

	test_select_employee_by_job_code
		local
			l_handler: DATABASE_HANDLER_IMPL
			l_connection: DATABASE_CONNECTION
		do
			l_connection := odbc_connection
			check l_connection.is_connected end
			create l_handler.make (l_connection)
			l_handler.set_query (query_employee_by_job_code ("Eng"))
			l_handler.execute_query
			if not l_handler.after then
				from
					l_handler.start
				until
					l_handler.after
				loop
						-- Row
						-- emp_no, first_name, last_name, phone_ext, hire_date, dept_no, job_code, job_grade, job_country, salary, full_name
					print ("--------------------------%N")
					if attached {DB_TUPLE} l_handler.item as l_item then
						if attached {INTEGER_16_REF} l_item.item (1) as l_emp_no then
							print ("emp_no: ")
							print (l_emp_no)
							io.put_new_line
						end
						if attached {STRING} l_item.item (2) as l_fn then
							print ("first_name: ")
							print (l_fn)
							io.put_new_line
						end
						if attached {STRING} l_item.item (3) as l_ln then
							print ("last_name: ")
							print (l_ln)
							io.put_new_line
						end
					end

					l_handler.forth
				end
			end
		end


feature  -- SQL helpers

	odbc_connection: DATABASE_CONNECTION
		do
			create {DATABASE_CONNECTION_ODBC} Result.login_with_connection_string (connection_string_firebird_server)
			check Result.is_connected end
		end

	query_employee_by_job_code (a_name: STRING): DATABASE_QUERY
		local
			a_parameters: STRING_TABLE [detachable ANY]
		do
			create a_parameters.make (1)
			a_parameters.put (a_name, "job_code")
			create Result.data_reader (SQL_query_employee_by_job_code,a_parameters)
		end

	SQL_query_employee_by_job_code: STRING = "SELECT emp_no, first_name, last_name, phone_ext, hire_date, dept_no, job_code, job_grade, job_country, salary, full_name FROM employee where job_code =:job_code;"

feature -- Connection String

	connection_string_firebird_server: STRING = "DRIVER=Firebird/InterBase(r) driver;UID=SYSDBA; PWD=masterkey; DBNAME=C:\home\test\eiffel_firebird\EMPLOYEE.FDB"
			-- DBNAME for Embedded Connections, update it as needed.
			-- https://www.firebirdsql.org/file/documentation/reference_manuals/user_manuals/html/qsg3-databases.html		
end
