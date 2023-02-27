function SendMailWithGmail(Sender,SenderPassword,Recipients,Subject,Message,Attachments)

% Sender = '';    %Your GMail email address
% SenderPassword = '';          %Your GMail password
% Set up Gmail SMTP service and email preferences.
setpref('Internet','E_mail',Sender);
setpref('Internet','SMTP_Server','smtp.gmail.com');
% setpref('Internet','SMTP_Server','smtp.aol.com'); % This works for AOL account
setpref('Internet','SMTP_Username',Sender);
setpref('Internet','SMTP_Password',SenderPassword);
% Gmail server.
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
props.setProperty('mail.smtp.starttls.enable','true');
%Send the email.
switch nargin
    case 5
        sendmail(Recipients,Subject,Message);
    case 6
        sendmail(Recipients,Subject,Message,Attachments);
    otherwise
        sendmail(Recipients,Subject);
end