<!--- Include data Source --->
<cfinclude template="config_data_source.cfm">

<!--- Email settings --->
<cfset application.mail.username = "ian.osullivan@example.com">
<cfset application.mail.password = "cork_rebel">
<cfset application.mail.server = "mail.example.com">
<cfset application.mail.from = "ian.osullivan@example.com">
<cfset application.mail.bcc = "">

<!--- Send Error email to --->
<cfset application.tech_support_email_list = "ian.osullivan@example.com">

<!--- Used in email --->
<cfset application.system_name = "Your System name here">

<!--- List the files that are allowed to bypass the security system meaning a user does not need to be logged in to access these
file. All other CF file access would require a user to be logged in.
This var is used in Application.cfc - onRequestStart()
Note these files can be anything you like. I've just listed some typical files I have... 
--->
<cfset application.security_bypass_files_list = "_test.cfm, act_checkUser.cfm, act_sendPassword.cfm, _ORM_code.cfm, json.cfm, map_data.cfm, json_data.cfm">

<!--- Used to prevent caching. Tag this onto the end of resources as a URL parameter (js, images, css to avoid caching) 
	example <script src="js/example.js?#application.version#">  --->
<cfset application.version = "2.0">
