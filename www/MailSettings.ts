class MailSettings {
    public emailFrom: string;
    public emailTo: string;
    public subject: string;
    public textBody: string;
    public smtp: string;
    public port: number;
    public smtpUserName: string;
    public smtpPassword: string;
    public smtpRequiresAuth: boolean;
    public attachmentsInBase64Format: Array<string>;
 
    constructor(mailSettings: any = undefined) {
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
}

 

