<cfcomponent output="false">

	<!--- application.data_source is set in here --->
	<cfinclude template="../config_data_source.cfm">

	<!---
	Define the application. By using the current template
	path, we can ensure that our application name completely
	unique across the entire server. By using the hash()
	function, we make the name more friendly.
	
	CGI.HTTP_HOST and cgi.https are added to ensure that site with/without 'www' at the front are also unique; 
	Example www.domain.com is different to domain.com and http://www.domain is different to https://www.domain.com
	This is most significant as it affects the global <base href=""> tag
	--->
	<cfset THIS.name = "[website-name-goes-here] - " & hash( getCurrentTemplatePath() & CGI.HTTP_HOST & cgi.HTTPS) />
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


		<!--- URL key/value pair check // Start --->
		<cfif ListLen(CGI.query_string, '/') GT 1>
			<!--- URL key/value pair check 1
			Example - http://app.locosoftware.ie/eveara_sul/testing/?/first_param/123/second_param/456.
			Note that there is no index.cfm file in the URL so it works directly on the folder --->
			<cfset key_value_list = CGI.query_string>			

		<cfelseif CGI.path_info NEQ CGI.script_name>
			<!--- URL key/value pair check 2
			 Check to see if we have some key/value pairs (in the format www.example.com/page.cfm/var1/foo/var2/bar) and put them into the URL struct.
			 If these are different then we got some key/value pairs in the URL of the site --->
			<cfset key_value_list = cgi.path_info>

		<cfelse>

			<cfset key_value_list = "">
		</cfif>

		<cfset key_value_list_len = ListLen(key_value_list, '/')>

		<!--- Clean the URL structure in case it contains rogue stuff
		<cfif key_value_list_len GT 1>
			<!--- <cfset URL = StructNew()> --->
			<cfset StructClear(URL)>
		</cfif> --->

		<cfset pair_iterator = 1>

		<cfloop condition="pair_iterator LTE #key_value_list_len#">
			<cfoutput>

				<cfif pair_iterator LT key_value_list_len>
					<cfset "URL.#ListGetAt(key_value_list, pair_iterator, '/')#" = "#ListGetAt(key_value_list, pair_iterator+1, '/')#">
				<cfelse>
					<cfset "URL.#ListGetAt(key_value_list, pair_iterator, '/')#" = "">
				</cfif>

			</cfoutput>

			<cfset pair_iterator += 2>
		</cfloop>
		<!--- URL key/value pair check // END --->

		<!--- Page reload message // Used in footer.cfm --->
		<cfparam name="session.message" default="">
		<cfparam name="session.logged_in" default="false"> <!--- Used through out the system --->
		<cfparam name="session.user.firstname" default=""> <!--- Needed for line 133 below in case the session has expired. Without this the system will crash --->

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
	            </cflock>
			
			<!--- Inform the Admin --->
			<cfset session.message = '<i class="fa fa-thumbs-up"></i> App Reloaded. CFCs and ORM reloaded successfully!'>
		</cfif>

		<!--- If serverReload is called or application is in full reload mode then run onApplicationStart to reload all singletons --->
        	<cfif (structKeyExists(url, "serverReload"))>
            		<!--- Create an exclusive lock to make this call thread safe --->
            		<cflock name="reloadServer" timeout="60" type="exclusive">
				<cfscript>
					objServer = createObject("component", "server");
					objServer.onServerStart();
				</cfscript>
            		</cflock>
		</cfif>


		<!--- Assume we are not processing a bypass file --->
		<cfset bypass_file = false>
		<!--- Check bypass files and folders list --->
		<cfif ListContains(application.security_bypass.files, GetFileFromPath(CGI.CF_TEMPLATE_PATH)) OR ListContains(application.security_bypass.folders, ListLast( GetDirectoryFromPath(CGI.CF_TEMPLATE_PATH), '\,/') ) >
			<cfset bypass_file = true>
			<!--- Suppress the layout as we typically don't want it for any of the bypass files as they are either Test/JSON/REST files --->
			<cfset nolayout = true>
		</cfif>

		<!--- If this is an Application (not website) and the user is not logged_in and not a bypass-file send user back to login page 
			Careful not to case a redirect loop
		--->
		<!--- <cfif !session.logged_in AND !bypass_file>
			<!--- Go to login page --->
			<cflocation url="#APPLICATION.settings.site_URL###Please%20Login" addtoken="false"/>
		</cfif> --->


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
	<cfif IsDefined("application.cfcs")>
		<cfset $ = application.cfcs>

	<cfelse>
		<!--- Might need to restart/reload the application and then reset --->
		<cfset onApplicationStart() />
		<cfset $ = application.cfcs>
	</cfif>


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
		<cfset ORMReload()>
		
		<!--- Clear the application scope to ensure it is cleared out --->
		<cfset StructClear(application)>
		<!--- Include general config settings --->
		<cfinclude template="../config_all.cfm">

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
			expandPath( CGI.script_name )
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
		<cfset APPLICATION.settings.webRoot = repeatString(
			"../",
			local.requestDepth
			) />
		
		<!--- We use ( cgi.HTTPS IS "on" ? "https://" : "http://" ) instead of just "//" because if we use this in emails the specified protocol is required --->
		<cfset APPLICATION.settings.site_URL = (
			( cgi.HTTPS IS "on" ? "https://" : "http://" ) &
			cgi.http_host &
			reReplace(
				getDirectoryFromPath( CGI.script_name ),
				"([^\\/]+[\\/]){#local.requestDepth#}$",
				"",
				"one"
				)
			) />
		
		<!--- The physical site root --->
		<cfset APPLICATION.settings.site_root = GetDirectoryFromPath(GETCurrentTemplatePath())>
		<!--- The site folder (used in error email) --->
		<cfset APPLICATION.settings.site_folder = ListLast(APPLICATION.settings.site_root, '\')>

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
			
			<!--- JS to show error --->
			<script type="text/javascript">
				function ShowError() {
					var e = document.getElementById('error_info');
					if(e.style.display == 'block')
						e.style.display = 'none';
					else {
						e.style.display = 'block';
						//Go to the error
						window.location.assign('#error_info');						
					}
				}
			</script>
			<!--- Send error if possible --->
			<cfif IsDefined("application.cfcs.error")>
				<cfset application.cfcs.error.SendMail(Arguments.Exception)>
			</cfif>


		</cfif>
	</cffunction>


	<cffunction name="CreateComponents" hint="Create ColdFusion components by looping through the directory">
		<cfset cfcs_relative_path = "application/cfcs">

		<cfset componenet_path = listChangeDelims(cfcs_relative_path,'.','/\')> <!--- The path for the <cfobject> below needs dots not slashes --->
		<cfset cfcs_full_path = getDirectoryFromPath(getCurrentTemplatePath()) & cfcs_relative_path>
		
		<cfdirectory directory="#cfcs_full_path#" name="cfc_list">

		<cfset application.cfcs = StructNew()>

		<cfloop query="cfc_list">
			<!--- Skip folders --->
			<cfif cfc_list.type EQ "file">
				<cfset file_extension = right(cfc_list.name, 4)>
			
				<!--- Only create components for '.cfc' files --->
				<cfif file_extension EQ ".cfc">
					<cfset cfc_name = mid( name, 1, len(name)-4 )>

					<!--- If you find any rogue characters in the component name skip it. Only aplha, number and underscores allowed --->
					<cfif !reFind('[^A-Za-z0-9_]',cfc_name)>
						<cfobject component="#componenet_path#.#cfc_name#" name="#componenet_path#.#cfc_name#">
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>



</cfcomponent>
