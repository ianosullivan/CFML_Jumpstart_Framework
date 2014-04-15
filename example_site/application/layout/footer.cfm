	<footer class="container">
		<p>&copy; Loco Software 2013</p>
	</footer>

	<div id="alert_container">
		<span class="alert alert-success">
			<!--- Populated by Alert() function in main.js --->
		</span>
	</div>
	<div id="alert_container_loader"></div>

	<!--- Is there a system message to output after page load --->
	<cfif session.message NEQ "">
		<script>
			Alert('<cfoutput>#session.message#</cfoutput>');
		</script>

		<cfset session.message = ""> <!--- Reset so it doesn't output again --->
	</cfif>

	<script>
		var _gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview']];
		(function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
		g.src='//www.google-analytics.com/ga.js';
		s.parentNode.insertBefore(g,s)}(document,'script'));
	</script>
</body>
</html>
