<cfcomponent output="false">

	<!--- application.data_source is set in here --->
	<cfinclude template="../config_data_source.cfm">

	<!---
	Define the application. By using the current template
	path, we can ensure that our application name completely
	unique across the entire server. By using the hash()
	function, we make the name more friendly.
	--->
	<cfset this.name = hash( getCurrentTemplatePath() ) />
	<!--- IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT
		*** If your components are in another folder ABOVE the webroot you need to create a mapping like this.
		*** See the comments in the OnApplicationStart function below
		<cfset this.mappings = structNew() />
		<cfset this.mappings["/CMS_CFC"] = getDirectoryFromPath(getCurrentTemplatePath()) & "../CMS/application/cfc"/>
	IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT --->

	<!--- ORM code initialisation code --->
	<cfset THIS.ormEnabled = true />
	<cfset THIS.datasource = application.data_source/> <!--- This is also the default data_source used by any cfquery tag --->
	<!--- Optional to specifiy ORM CFC location.
	If not specified the whole app is scanned  --->
	<cfset THIS.ormsettings.cfclocation = "application/ORM" />

	<cfset THIS.SessionManagement = true />
	<cfset THIS.SessionTimeout = CreateTimeSpan(0,2,0,0) />


	<!--- Layout manager --->
	<cffunction name="OnRequestStart" returntype="boolean" output="true">
		<!--- See here for more about the dynamic URL path code...
			http://www.bennadel.com/blog/1655-Ask-Ben-Dynamic-Web-Root-And-Site-URL-Calculations-In-Application-cfc.htm --->
		<!--- Define arguments. --->
		<cfargument
			name="template"
			type="string"
			required="true"
			hint="I am the template requested by the user."
			/>

		<!--- Define the local scope. --->
		<cfset local = {} />

		<!--- Define request settings. --->
		<cfsetting showdebugoutput="false" />

		<!---
			Set the value of the web root. Since we know that this
			template (Application.cfc) is in the web root for this
			application, all we have to do is figure out the
			difference between this template and the requested
			template. Every directory difference will require our
			webroot to have a "../" in it.
		--->

		<!---
			Get the current (Application.cfc) directory path based
			on the current template path.
		--->
		<cfset local.basePath = getDirectoryFromPath(
			getCurrentTemplatePath()
			) />

		<!---
			Get the target (script_name) directory path based on
			expanded script name.
		--->
		<cfset local.targetPath = getDirectoryFromPath(
			expandPath( arguments.template )
			) />

		<!---
			Now that we have both paths, all we have to do is
			find the difference in path. We can treat the paths
			as slash-delimmited lists. To do this, let's calculate
			the depth of sub directories.
		--->
		<cfset local.requestDepth = (
			listLen( local.targetPath, "\/" ) -
			listLen( local.basePath, "\/" )
			) />

		<!---
			With the request depth, we can easily create our
			web root by repeating "../" the appropriate number
			of times.
		--->
		<cfset request.webRoot = repeatString(
			"../",
			local.requestDepth
			) />

		<!---
			While we wouldn't normally do this for every page
			request (it would normally be cached in the
			application initialization), I'm going to calculate
			the site URL based on the web root.
		--->
		<!---<cfset request.site_URL = (
			"http://" &
			cgi.server_name &
			reReplace(
				getDirectoryFromPath( arguments.template ),
				"([^\\/]+[\\/]){#local.requestDepth#}$",
				"",
				"one"
				)
			) />--->
		<!---
			Changed by Ian O'Sullivan so that it will work for localhost development environment also.
			replaced cgi.server_name with cgi.http_host as it picks up the port also.
		--->
		<cfset request.site_URL = (
			"http://" &
			cgi.http_host &
			reReplace(
				getDirectoryFromPath( arguments.template ),
				"([^\\/]+[\\/]){#local.requestDepth#}$",
				"",
				"one"
				)
			) />

		<!---
			URL key/value pair check // START
		 Check to see if we have some key/value pairs (in the format www.example.com/page.cfm/var1/foo/var2/bar) and put them into the URL struct.
		 If these are different then we got some key/value pairs in the URL of the site --->
		<cfif CGI.path_info NEQ CGI.script_name>
			<cfset key_value_list = cgi.path_info>
		<cfelse>
			<cfset key_value_list = "">
		</cfif>

		<cfset key_value_list_len = ListLen(key_value_list, '/')>
		<cfset iterator = 1>

		<cfloop condition="iterator LTE #key_value_list_len#">
			<cfoutput>

				<cfif iterator LT key_value_list_len>
					<cfset "URL.#ListGetAt(key_value_list, iterator, '/')#" = "#ListGetAt(key_value_list, iterator+1, '/')#">
				<cfelse>
					<cfset "URL.#ListGetAt(key_value_list, iterator, '/')#" = "">
				</cfif>

			</cfoutput>

			<cfset iterator += 2>
		</cfloop>
		<!--- URL key/value pair check // END --->


		<!--- Page reload message // Used in footer.cfm --->
		<cfparam name="session.message" default="">
		<cfparam name="session.logged_in" default="false"> <!--- Used through out the system --->
		<cfparam name="session.user.firstname" default=""> <!--- Needed for line 133 below in case the session has expired. Without this the system will crash --->

		<!--- The physical site root --->
		<cfset REQUEST.site_root = GetDirectoryFromPath(GETCurrentTemplatePath())>
		<!--- The site folder (used in error email) --->
		<cfset REQUEST.site_folder = ListLast(REQUEST.site_root, '\')>

		<!--- Check if we are trying to logout the current user => clear the current session  --->
		<cfif structKeyExists( url, "logout" )>
			<!--- Get the user first name so that we can give them a personalised message after logout --->
			<cfset name = session.user.firstname>

			<!--- Clear all of the session cookies. This will expire them on the user's computer when the CFLocation below executes --->
			<!---
			<cfloop index="local.cookieName" list="cfid,cftoken,cfmagic">
				<!--- Expire this session cookie. --->
				<cfcookie name="#local.cookieName#"	value="" expires="now"/>
			</cfloop>
			--->
			<!--- Clear the session --->
			<cfset StructClear(session)>

			<!--- Redirect back to the primary page (the dot at the start of the URL) and use window.location.hash to pass a message through.
				This is picked up in main.js and uses the Alert() function to give the user a message.
				window.location.hash is emptied straight after so that the message doens't appear again if the user reloads the page --->
			<cflocation url=".##You are now logged out of the system." addtoken="false"/>
		</cfif>

		<!--- If reload is called or application is in full reload mode then run onApplicationStart to reload all singletons --->
        	<cfif structKeyExists(url, "APPReload")>
	            <!--- Create an exclusive lock to make this call thread safe --->
	            <cflock name="reloadApp" timeout="60" type="exclusive">
	
	                <!--- Reload the app --->
	                <cfset onApplicationStart() />
			<cfset ORMReload()>
	            </cflock>
			
			<!--- Inform the Admin --->
			<cfset session.message = '<i class="fa fa-thumbs-up"></i> App Reloaded. CFCs and ORM reloaded successfully!'>
		</cfif>

		<cfif NOT IsDefined("nolayout")>
			<!--- Full Header --->
			<cfinclude template="application/layout/header.cfm">
		</cfif>

		<cfreturn true/>
	</cffunction>


	<!--- Only reason this is here is to create a global variable for CFC calls --->
	<cffunction name="OnRequest" access="public" returntype="void" output="true" hint="Fires after pre page processing is complete.">
        <!--- Define arguments. --->
        <cfargument name="TargetPage" type="string" required="true"/>

		<!--- Set global '$' variable to access components --->
		<cfset $ = application.cfcs>

        <!--- Include the requested page. --->
        <cfinclude template="#ARGUMENTS.TargetPage#" />

        <!--- Return out. --->
        <cfreturn />
    </cffunction>



	<cffunction name="OnRequestEnd" returntype="boolean" output="true">

		<cfif NOT IsDefined("nolayout")>
			<!--- Footer --->
			<cfinclude template="application/layout/footer.cfm">
		</cfif>
		<cfreturn true/>
	</cffunction>


	<!--- Call this by passing 'APPReload' into the URL --->
	<cffunction name="onApplicationStart" output="false">
		<!--- Clear the application scope to ensure it is cleared out --->
		<cfset StructClear(application)>
		<!--- Include general config settings --->
		<cfinclude template="../config_all.cfm">

		<!--- Dynamically create components --->
		<cfset CreateComponents()>

		<!--- IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT
			*** The below is used along with the CFC mappings variable if the components are ABOVE the webroot
		IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT : IMPORTANT --->
		<!---
			2 options using the mappings variable above.
			<cfset application.cfcs.user = new CMS_CFC.user() />
			<cfobject component="CMS_CFC.error" name="application.cfcs.error">
		--->
	</cffunction>


	<cffunction name="onError">
		<cfargument name="Exception" required=true/>
		<cfargument type="String" name="EventName" required=true/>

        	<!--- Initialize the error component
		<cfset application.cfcs.error = new application.coms.error()>--->

		<!--- Display an error message if there is a page context. --->
		<cfif NOT (Arguments.EventName IS "onSessionEnd") OR (Arguments.EventName IS "onApplicationEnd")>

			<cfset test_page = false>
			<cfif ListContains('_test.cfm', GetFileFromPath(CGI.CF_TEMPLATE_PATH))>
				<cfset test_page = true>
			</cfif>

			<!--- Only output the GUI as long as the layout is NOT supressed. Output errors for the '_test.cfm' page'--->
			<cfif !IsDefined("nolayout") OR test_page>
				<cfoutput>
					<div class="alert alert-danger alert-dismissable">
					  <!--<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>-->
						<h2>An unexpected Error has occurred.</h2>

						An email has been sent to the <span id="error_click" title="Click to view the technical information below" onclick="ShowError()">technical team</span> who will investigate immediately.<br>
						Apologies for any inconvenience caused!
					</div>

					<!--- Shown on click of 'technical team' above --->
					<div id="error_info" <cfif !test_page>style="display:none"</cfif> >
					    <h4>Error dump...</h4>
					    <cfdump var=#Arguments.Exception#>

						<h4>CGI dump</h4>
						<cfdump var=#CGI#>
					</div>
				</cfoutput>
			</cfif>

			<cfset application.cfcs.error.SendMail(Arguments.Exception)>

		</cfif>
	</cffunction>


	<cffunction name="CreateComponents" hint="Create ColdFusion components by looping through the directory">

		<cfset cfcs_path = REQUEST.site_root & "application\cfcs">
		<cfdirectory directory="#cfcs_path#" name="cfc_list">

		<cfloop query="cfc_list">
			<cfif cfc_list.type EQ "file">
				<cfset cfc_name = Mid( name, 1, len(name)-4 )>
				<cfobject component="application.cfcs.#cfc_name#" name="application.cfcs.#cfc_name#">
			</cfif>
		</cfloop>

	</cffunction>


</cfcomponent>
