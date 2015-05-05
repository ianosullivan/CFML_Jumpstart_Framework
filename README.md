##General Info

* System uses **base href=”#request.webRoot#”** tag so all sources for images, css and scripts are relative to the base path URL. This is very important as all AJAX calls are relevant to the base tag. Using the dynamic base tag means you don’t need to worry about paths when releasing code. This makes use of Ben Nadels dynamic URL code, which he has kindly given me persmission to use.
* Components are declared in the application/cfcs folder. They are dynamically initialized in OnApplicationStart() function in Appliction.cfc. This means you do not need to initialize a component before use as it is already initialized.
* Application.cfc also has instructions on how to have external components. 
* Additionally you can use the global '$' variable to access your components. Note: '$' is a global variable for 'application.cfcs'. *Example usage: $.user.getName() -> $.component.function*
* Functioning global Error handler within Application.cfc. This presents a standard 'nice' message to user while also allowing a techie to click the words 'technical team' to get a full breakdown of the error. The error handler of course sends an email to the *application.tech_support_email_list* variable also. This is set in the *config_all.cfm* file
* System uses 2 config_~.cfm files that are in the same folder location as the webroot.
* Global Layout is managed by OnRequestStart() and onRequestEnd() application.cfc functions and files are located in application/layout/ folder.c
* ORM is enabled and files are located in application/ORM folder
* Functioning Login & Logout buttons
* Uses bootstrap 3.0 and FontAwesome 4.0.1, Responsive Design.
* **IMPORTANT**:: Any changes to CFCs or ORM requires an application reload - firing the onApplicationStart() function. Do this by passing *?AppReload* into the URL. 
* Note: System also supports key/value URL pairs e.g. index.cfm/nolayout/true, index.cfm/appreload




##Javascript stuff

* For AJAX calls just add ?nolayout (or /nolayout) to the URL
* Has a function called **Alert('add your HTML here')** which is useful to unobtrusively notify users of soemthing - Works well with font awesome e.g. Alert('<i class="fa fa-thumbs-up"></i> dark thumbs up!!');
* Also has an AlertLoading('your HTML here') which nicely blocks out the viewport with a message. Use AlertHide() to close it
* Alert() function automatically called if URL has a hash value. Note this is how logout works.
* If session.message is populated Alert() is automatically called. Note this is how login works.
* Has getURLParameter(variable_name) function to pull URL vars into JS.




##Database Info

* Uses data source ‘_Template_DB’.
* DB has one table users 
* Table has one record to demonstrate login.
