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

<!--- List the files and folders that are allowed to bypass the security system...
	This var is used in Application.cfc - onRequestStart()
--->
<cfset application.security_bypass.files = "_test.cfm, act_checkUser.cfm, act_registerUser.cfm, act_sendPassword.cfm, _ORM_code.cfm, activate.cfm, save_payment.cfm">
<cfset application.security_bypass.folders = "testing, rest">

<!--- Used to prevent caching. Tag this onto the end of resources as a URL parameter (js, images, css to avoid caching) 
	example <script src="js/example.js?#application.reload_date#">.
	Using this approach we still get the benefits of caching but we can force an update by putting '?Appreload' in the URL
--->
<cfset application.reload_date = dateFormat(now(), 'yyyyddmm') & "-" & timeFormat(now(), 'Hnn')>
