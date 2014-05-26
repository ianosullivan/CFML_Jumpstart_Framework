$(function(){
	
	//Check for window hash message
	if(window.location.hash != ''){
		//Extract and decode the message
		Alert( decodeURI(window.location.hash).substring(1) );
		window.location.hash = '';
	}

	//Sign in button
	$('#btn-sign-in').on('click', function(e){
		e.preventDefault(); // avoid default form submit
		
		AlertLoading('Loading');		
		
		$.post('login/act_checkUser.cfm?' + $('#frmLogin').serialize())
		.success(function(data) {
			//console.log(JSON.parse(data)); 
			//console.log(JSON.parse(data).response);
			
			//Check that it didn't fail			
			if(JSON.parse(data).response === true){				
				//If Remember Me is checked save the values to local storage
				/*
				if( $('#chkRememberMe').prop('checked') ){
					localStorage.setItem( "username", $('#txtEmail').val() );
					localStorage.setItem( "password", $('#txtPassword').val() );					
				}
				else {
					//Just clear all localStorage because we only store the username and password in it at the moment
					while (localStorage.length) localStorage.removeItem(localStorage.key(0));
				}
				*/
				//Reload the current page as the user is now logged
				//Note: we don't want to do a straight reload as we want to remove and URL params (if any).
				var reload_url = window.location.href.split('?')[0];
				reload_url = reload_url.split('#')[0];
				window.location.assign(reload_url);
			}
			else {
				AlertHide();
				Alert('<i class="fa fa-thumbs-down"></i> Your login details are incorrect');
			};
		})
		.error(function(data) { 
			Alert("Something went wrong. Try that again please."); 
		})
		.complete(function(data) { 
			//alert("complete"); 
		});
	});
});

var alert_timeout; //Store the setTimeout function call so we can clear it if we need to. This is needed if Alert() is called quickly in succession.

//Slide Down alert panel
function Alert(html, seconds){
	var m_seconds = 4000; // Default 4 seconds
	var m_html = '<i class="fa fa-info-circle"></i> Looks like you haven\'t passed in the HTML parameter??'; //Default message
	
	if(html != undefined){
		m_html = html; // Set seconds
	} 
	
	if(seconds != undefined){
		m_seconds = seconds * 1000; // Set miliseconds
	} 
	
	$('#alert_container_loader').fadeOut('fast');
	//In case it already exists
	clearTimeout(alert_timeout);

	$('#alert_container .alert').html(m_html).parent().css({'marginTop': '0px'});
	//Close after 'm_seconds' seconds
	alert_timeout = setTimeout(function(){
		AlertHide();
	}, m_seconds);

	//Example usage
	//Alert('<i class="fa fa-thumbs-up"></i> dark thumbs up!!');
	//Alert('<i class="fa fa-thumbs-o-up"></i> Open thumbs up!!');
	//Alert('<i class="fa fa-times"></i> X close button');
	//Alert('<i class="fa fa-info-circle"></i> info icon...');
}

function AlertLoading(txt){
	$('#alert_container_loader').fadeIn('fast');
	if(txt != undefined){
		$('#alert_container .alert').html('<i class="fa fa-spinner fa-spin"></i>&nbsp;&nbsp;' + txt).parent().css({'marginTop': '0px'});
	}
	else {
		$('#alert_container .alert').html('<i class="fa fa-spinner fa-spin"></i>&nbsp;&nbsp;Loading...').parent().css({'marginTop': '0px'});
	}
}

function AlertHide(){
	$('#alert_container_loader').fadeOut('fast');
	$('#alert_container').css({'marginTop':'-80px'});
}

function AlertError(){
	$('#alert_container_loader').fadeOut('fast');
	Alert('<i class="fa fa-times-circle"></i> An error has occurred. Please try that again.');
}

//Used in latest_updates page...
function getURLParameter(name) {
    return decodeURI(
        (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[,null])[1]
    );
}

function ShowError(){
	$('#error_info').css({'display':'block'});
}
