<!--- ORM User --->
<cfcomponent persistent="true">
	<cfproperty name="user_id" fieldtype="id" generator="native">
	<cfproperty name="firstname">
	<cfproperty name="surname">
	<cfproperty name="email">
	<cfproperty name="password">
	<cfproperty name="user_status">
	<cfproperty name="reset_password">
	<cfproperty name="user_level">
	<cfproperty name="date_added">
	<cfproperty name="last_login_date">

	<!--- Return full name --->
	<cffunction name="getFullName" returntype="string">
		<cfset full_name = getfirstname() & " " & getsurname()>
		<cfreturn full_name>
	</cffunction>

</cfcomponent>
