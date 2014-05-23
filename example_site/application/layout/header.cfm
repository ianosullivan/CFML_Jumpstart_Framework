<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title></title>
	<meta name="description" content="">
	<meta name="viewport" content="width=device-width">

	<!--- !!!!!! <base> tag is VERY IMPORTANT !!!!!! 
		This ensures images, hrefs and script sources use a FQDN to the file location throughout the site.
		This ensures that any subfolders have the correct locations to assets
	--->
	<cfoutput>
	<base href="#request.site_URL#"/>
		
	<link rel="stylesheet" href="css/bootstrap.min.css?#application.version#">
	<style>
		body {
			padding-top: 50px;
			padding-bottom: 20px;
		}
	</style>
	<link rel="stylesheet" href="css/bootstrap-theme.min.css?#application.version#">
	<link rel="stylesheet" href="css/main.css?#application.version#">
	<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/font-awesome/4.0.1/css/font-awesome.min.css?#application.version#">
	
	<script src="js/vendor/modernizr-2.6.2-respond-1.1.0.min.js?#application.version#"></script>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js?#application.version#"></script>
	<script>window.jQuery || document.write('<script src="js/vendor/jquery-1.10.1.min.js"><\/script>')</script>
	<script src="js/vendor/bootstrap.min.js?#application.version#"></script>
	<script src="js/main.js?#application.version#"></script>
	</cfoutput>
</head>

<body>
	<!--[if lt IE 7]>
	<p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
	<![endif]-->
	
	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="#">Project name</a>
			</div>
			<div class="navbar-collapse collapse">
				<ul class="nav navbar-nav">
					<li class="active"><a href="#">Home</a></li>
					<li><a href="#example1">Example 1</a></li>
					<li><a href="#example2">Example 2</a></li>
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="#">Action</a></li>
							<li><a href="#">Another action</a></li>
							<li><a href="#">Something else here</a></li>
							<li class="divider"></li>
							<li class="dropdown-header">Nav header</li>
							<li><a href="#">Separated link</a></li>
							<li><a href="#">One more separated link</a></li>
						</ul>
					</li>
				</ul>
				
				<cfif !session.logged_in>
					<form id="frmLogin" class="navbar-form navbar-right">
						<div class="form-group">
							<input type="text" placeholder="Email" name="txtEmail" class="form-control" value="ian.osullivan@locosoftware.ie">
						</div>
						<div class="form-group">
							<input type="password" placeholder="Password" name="txtPassword" class="form-control" value="test">
						</div>
						<button type="submit" id="btn-sign-in" class="btn btn-success">Log in <i class="fa fa-sign-in"></i></button>
						<!--<button type="submit" class="btn btn-info">Register</button>-->
					</form>
				<cfelse>	
					<div id="frm-sign-out" class="navbar-form navbar-right">
						<a class="btn btn-success" href=".?logout">Logout <i class="fa fa-sign-out"></i></a>
					</div>
				</cfif>	
				
			</div>
			<!--/.navbar-collapse -->
		</div>
	</div>
