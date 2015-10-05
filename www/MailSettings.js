var MailSettings = (function () {
    function MailSettings(mailSettings) {
        if (mailSettings === void 0) { mailSettings = undefined; }
        if (mailSettings != undefined) {
            this.emailFrom = mailSettings.emailFrom;
            this.emailTo = mailSettings.emailTo;
            this.smtp = mailSettings.smtp;
            this.port = mailSettings.port;
            this.smtpUserName = mailSettings.smtpUserName;
            this.smtpPassword = mailSettings.smtpPassword;
            this.attachmentsInBase64Format = mailSettings.attachmentsInBase64Format;
            this.subject = mailSettings.subject;
            this.textBody = mailSettings.textBody;
        }
    }
    return MailSettings;
})();