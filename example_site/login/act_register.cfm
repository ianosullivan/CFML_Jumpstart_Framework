<cfsilent>

<!--- Create new user object --->
<cfset user = EntityNew("users")>

<cfset user.setfirstname(txtFirstName)>
<cfset user.setsurname(txtLastName)>
<cfset user.setemail(txtEmail)>
<cfset user.setpassword(hash(txtRegisterPassword))> <!--- We 'hash' the password as it is being saved into the DB --->
<cfset user.setuser_status(1)> <!--- 1 is 'active'' --->
<cfset user.setreset_password(false)>
<cfset user.setuser_level(1)> <!--- 1 is normal, 2 is admin --->
<cfset user.setdate_added(now())>

<cfparam name="chkReceiveUpdates" default="0">
<cfparam name="chkReceiveInfo" default="0">

<cfset user.setreceive_updates(chkReceiveUpdates)>
<cfset user.setreceive_information(chkReceiveInfo)>
<cfset user.setregistration_complete(false)> <!--- Initial registration --->

<cftry>
	<cfset EntitySave(user)>

	<!--- Save to session. Use serialize & deserilalize JSON instead of having to individually save user items.
		User object saves to session as a struct --->
	<!--- <cfset session.user = Deserializejson(SerializeJson(user))> --->
	<cfset session.user.id = user.getuser_id()>
	<cfset session.user.firstname = txtFirstName>
	<cfset session.user.fully_registered = false>
	<cfset session.logged_in = true>

	<cfset response = '{"response":true}'>

	<cfcatch>
		<!--- Save error --->
		<cfset response = '{"response":false}'>
	</cfcatch>
</cftry>
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
