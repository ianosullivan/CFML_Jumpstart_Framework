<cfcomponent>

	<cffunction name="SendMail">
        <cfargument name="error_object" type="any">

		<cfmail subject="Error in system - #application.system_name# (#REQUEST.site_folder#)"
		    to="#application.tech_support_email_list#"
		    from="#application.mail.username#"
		    wraptext="50"
		    username="#application.mail.username#"
		    password="#application.mail.password#"
		    server="#application.mail.server#"
		    type="html">

			<html>
			<head>
				<style type="text/css">
					<cfinclude template="../../css/error_email.css">
				</style>
			</head>
			<body>

			    <h4>ERROR dump...</h4>
			    <cfdump var=#error_object#>

				<h4>CGI dump</h4>
				<cfdump var=#CGI#>

				<h4>SESSION dump</h4>
				<cfdump var=#SESSION#>

				<h4>REQUEST dump</h4>
				<cfdump var=#REQUEST#>
			</body>
		    </html>

		</cfmail>

	</cffunction>

</cfcomponent>