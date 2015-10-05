# Cordova SMTP Client

Simple pluging that sends an email with or without attachments without prompt the user.

## ps. IOS is working Android is under development

## Using

Install the plugin using your any plugman compatible cli

    $ cordova plugin add https://github.com/albernazf/cordova-smtp-client.git

Install iOS and/or Android platform

    cordova platform add ios
    cordova platform add android    

Under the plugins / com.cordova.smtp.client / www folder you will find a Typescript file to help you use the plugin (not mandatory) MailSettings.ts, if you are not using typescript there is also a javascript version of it under the same folder MailSettings.js.

On your javascript call use a code similar to this.

	var mailSettings = {
	    emailFrom: "emailFrom@domain.com",
	    emailTo: "emailTo@domain.com",
	    smtp: "smtp-mail.domain.com",
	    smtpUserName: "authuser@domain.com",
	    smtpPassword: "password",
	    attachmentsInBase64Format: ["attchament1_in_base64_formant","attchament2_in_base64_formant"], // optional
	    subject: "email subject",
		textBody: "write something within the boddy of the email"
	};
	            
	var success = function(message) {
		alert(message);
	}
	
	var failure = function(message) {
		alert("Error sending the email");
	}			
				
	smtpClient.sendMail(mailSettings, success, failure);

The return object "message" has the following structure

	{
	    success : bool,
		errorCode : int,
		errorMessage : string	    
	}
