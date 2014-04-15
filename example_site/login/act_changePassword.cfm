<cfsilent>

<!--- Create new user object --->
<cfset user = EntityLoadByPK("users", session.user.id)>
<!--- <cfset user.setpassword(hash('test'))>
<cfdump var="#user#" expand="false"> --->

<cfif hash(txtCurrentPassword) EQ user.getpassword()>

	<cfset user.setpassword(hash(txtNewPassword))> <!--- We 'hash' the password as it is being saved into the DB --->
	<cfset EntitySave(user)>
		
	<cfset response = '{"current_password_correct":true}'>

<cfelse>
	<!--- Invalid Password --->
	<cfset response = '{"current_password_correct":false}'>	
</cfif>
	
</cfsilent>

<cfoutput>#response#</cfoutput>
<!--- 
<cfif !IsDefined("valid_user")>
	<cfset valid_user = "">
	<cfset response = '{"response":false}'>
<cfelse>
	<!--- Save to session. Use serialize & deserilalize JSON instead of having to individually save user items. 
		User object saves to session as a struct --->
	<cfset session.user = Deserializejson(SerializeJson(valid_user))>
	<cfset response = '{"response":true}'>
</cfif>


 --->
