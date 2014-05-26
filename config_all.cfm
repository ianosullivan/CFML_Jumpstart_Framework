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

<!--- Used to prevent caching. Tag this onto the end of resources as a URL parameter (js, images, css to avoid caching) 
	example <script src="js/example.js?#application.version#">  --->
<cfset application.version = "2.0">
