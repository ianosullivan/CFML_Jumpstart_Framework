<cfsilent>
<cfset valid_user = ORMExecuteQuery("
	Select u
	from users as u
	where u.email = '#txtEmail#'
	and u.password = '#hash(txtPassword)#'
", true)>

<cfif !IsDefined("valid_user")>
	<cfset valid_user = "">
	<cfset response = '{"response":false}'>
<cfelse>
	<!--- Set the last login date 
	<cfset valid_user.setlast_login_date(now())>
	--->

	<!--- Save to session. Use serialize & deserilalize JSON instead of having to individually save user items.
		User object saves to session as a struct
	<cfset session.user = Deserializejson(SerializeJson(valid_user))>--->
	<cfset session.user.id = valid_user.getuser_id()>

	<cfset session.logged_in = true>  <!--- Used throughout the system. This is cfparam'ed to false in Application.cfc --->

	<!--- Page reload message // Used in footer.cfm --->
	<cfset session.message = '<i class="fa fa-thumbs-up"></i> You have successully logged in.'>

	<cfset response = '{"response":true}'>
</cfif>

<!--- Not used JSON response is not used at the moment but might be down the line
<cfoutput>#SerializeJson(valid_user)#</cfoutput>
--->

</cfsilent>
<!--- JSON response is not used at the moment but might be down the line --->
<cfoutput>#response#</cfoutput>