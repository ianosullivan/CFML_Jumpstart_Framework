##General Info

* System uses <base href=”#request.webRoot#”> tag so all sources for images, css and scripts are relative to the base path URL. This is very important as all AJAX calls are relevant to the base tag. Using the dynamic base tag means you don’t need to worry about paths when releasing code. This makes use of Ben Nadels dynamic URL code, which he has kindly given me persmission to use.
* Single instance components are declared in application/cfc folder and are initialized in OnApplicationStart() function in Appliction.cfc. New components should be referenced here. Also has instructions on how to have external components.
* Functioning global Error handler within Application.cfc. This presents a standard 'nice' message to user while also allowing a techie to click the words 'technical team' to get a full breakdown of the error. The error handler of course sends an email to the *application.tech_support_email_list* variable also. This is set in the *config_all.cfm* file
* System uses 2 config_~.cfm files that are in the same folder location as the webroot.
* Global Layout is managed by OnRequestStart() and onRequestEnd() application.cfc functions and files are located in application/layout/ folder.
* ORM is enabled and files are located in application/ORM
* Functioning Login & Logout buttons
* Uses bootstrap 3.0 and FontAwesome 4.0.1, Responsive Design.
* **IMPORTANT**:: Any changes to CFCs or ORM requires a reload. Do this by passing *?AppReload=loco* into the URL. Note: System also supports key/value URL pairs e.g. index.cfm/AppReload/loco




##Javascript stuff

* For AJAX calls just add **?nolayout** (or /nolayout/true) if you prefer
* Has a function called **Alert('add your HTML here')** which is useful to unobtrusively notify users of soemthing - Works well with font awesome e.g. Alert('<i class="fa fa-thumbs-up"></i> dark thumbs up!!');
* Also has an AlertLoading('your HTML here') which nicely blocks out the viewport with a message. Use AlertHide() to close it
* Alert() function automatically called if URL has a hash value. Note this is how logout works.
* If session.message is populated Alert() is automatically called. Note this is how login works.
* Has getURLParameter(variable_name) function to pull URL vars into JS.




##Database Info

* Uses data source ‘_Template_DB’.
* DB has one table users 
* Table has one record to demonstrate login.
