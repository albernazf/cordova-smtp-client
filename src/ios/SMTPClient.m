package com.cordova.smtp.client;

import android.os.Environment;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

public class SMTPClient extends CordovaPlugin {
    public final String ACTION_SEND_EMAIL = "cordovaSendMail";

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if (action.equals(ACTION_SEND_EMAIL)) {

            final String jsonObject = args.getString(0);
            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    try {
                        JSONObject json = new JSONObject(jsonObject);

                        sendEmailViaGmail(json);
                        callbackContext.success();
                    } catch (JSONException ex) {
                        callbackContext.error(ex.getMessage());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
            return true;

        }
        return false;
    }

    private final void sendEmailViaGmail(JSONObject json) throws Exception {

        Mail m = new Mail(json.getString("smtpUserName"), json.getString("smtpPassword"));
        String[] toArr = {json.getString("emailTo")};
        m.set_to(toArr);
        m.set_host(json.getString("smtp"));
        m.set_from(json.getString("emailFrom"));
        m.set_body(json.getString("textBody"));
        m.set_subject(json.getString("subject"));
        m.set_auth(json.getBoolean("auth"));
        m.set_ssl(json.getBoolean("ssl"));
        if(json.has("sport")){
            m.set_sport(json.getInt("sport"));
        }

        if(json.has("port")){
            m.set_port(json.getInt("port"));
        }
    
        JSONArray attachments = json.getJSONArray("attachments");
        if (attachments != null) {
            for (int i = 0; i < attachments.length(); i++) {
                String fileFullName = attachments.getString(i);
                fileFullName = "file:/storage/sdcard/Android/data/com.yourname.workshop/cache/modified.jpg";
                if (fileFullName.contains(":")) {
                    fileFullName = fileFullName.split(":")[1];
                }
                m.addAttachment(fileFullName);
            }
        }

        boolean sendFlag = m.send();

    }

}