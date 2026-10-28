package com.example.imsdkhost;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.Insets;
import android.os.Bundle;
import android.os.Build;
import android.text.InputType;
import android.text.method.PasswordTransformationMethod;
import android.view.DisplayCutout;
import android.view.View;
import android.view.WindowInsets;
import android.view.WindowInsetsController;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import com.imsdk.nativebridge.ImSdk;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/** Pure Java host. SDK owns account/password login and conversations. */
public final class MainActivity extends Activity {
    private EditText configuration;
    private EditText credentials;
    private EditText target;
    private CheckBox consent;
    private TextView status;
    private TextView events;
    private Map<String, Object> suppliedConfiguration;
    private boolean openingMessenger;

    private boolean diagnosticsEnabled() {
        return BuildConfig.DEBUG && ("1".equals(getIntent().getStringExtra("IMSDK_HOST_DIAGNOSTICS")) ||
            getIntent().hasExtra("IMSDK_HOST_PRIVATE_CONFIG_PATH"));
    }

    @Override public void onCreate(Bundle state) {
        super.onCreate(state);
        ScrollView scroll = new ScrollView(this);
        LinearLayout content = new LinearLayout(this);
        content.setOrientation(LinearLayout.VERTICAL);
        int padding = (int) (16 * getResources().getDisplayMetrics().density);
        content.setPadding(padding, padding, padding, padding);
        scroll.addView(content);
        setContentView(scroll);
        configureSystemBars(scroll);

        status = new TextView(this);
        status.setContentDescription("聊天服务状态");
        events = new TextView(this);
        if (diagnosticsEnabled()) buildDiagnosticsContent(content);
        else buildMessengerContent(content);
        content.addView(status);
        if (diagnosticsEnabled()) content.addView(events);
        ImSdk.setEventListener(event -> {
            Object type = event.get("type");
            if (diagnosticsEnabled()) events.setText("SDK event: " + (type instanceof String ? type : "event"));
        });
    }

    /** Keeps both host screens clear of edge-to-edge system bars and cutouts. */
    private void configureSystemBars(ScrollView scroll) {
        scroll.setBackgroundColor(Color.WHITE);
        View decor = getWindow().getDecorView();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            getWindow().setDecorFitsSystemWindows(false);
            WindowInsetsController controller = getWindow().getInsetsController();
            if (controller != null) {
                int lightBars = WindowInsetsController.APPEARANCE_LIGHT_STATUS_BARS |
                    WindowInsetsController.APPEARANCE_LIGHT_NAVIGATION_BARS;
                controller.setSystemBarsAppearance(lightBars, lightBars);
            }
        } else {
            int visibility = decor.getSystemUiVisibility() |
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
                View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
                View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION |
                View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                visibility |= View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR;
            }
            decor.setSystemUiVisibility(visibility);
        }
        getWindow().setStatusBarColor(Color.TRANSPARENT);
        // Android 7 cannot show dark navigation icons; keep their background dark.
        getWindow().setNavigationBarColor(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
            ? Color.TRANSPARENT : Color.BLACK);
        scroll.setOnApplyWindowInsetsListener((view, windowInsets) -> {
            int left;
            int top;
            int right;
            int bottom;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                Insets safe = windowInsets.getInsets(
                    WindowInsets.Type.systemBars() | WindowInsets.Type.displayCutout());
                left = safe.left;
                top = safe.top;
                right = safe.right;
                bottom = safe.bottom;
            } else {
                left = windowInsets.getSystemWindowInsetLeft();
                top = windowInsets.getSystemWindowInsetTop();
                right = windowInsets.getSystemWindowInsetRight();
                bottom = windowInsets.getSystemWindowInsetBottom();
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    DisplayCutout cutout = windowInsets.getDisplayCutout();
                    if (cutout != null) {
                        left = Math.max(left, cutout.getSafeInsetLeft());
                        top = Math.max(top, cutout.getSafeInsetTop());
                        right = Math.max(right, cutout.getSafeInsetRight());
                        bottom = Math.max(bottom, cutout.getSafeInsetBottom());
                    }
                }
            }
            // Insets are applied to the outer scroll view; the content keeps
            // its original 16 dp padding, without accumulating on redispatch.
            view.setPadding(left, top, right, bottom);
            return windowInsets;
        });
        scroll.requestApplyInsets();
    }

    private void buildMessengerContent(LinearLayout content) {
        TextView title = new TextView(this);
        title.setText("聊天");
        title.setTextSize(24);
        content.addView(title);
        TextView help = new TextView(this);
        help.setText("登录后即可查看会话，与联系人或群组聊天。");
        content.addView(help);
        try (InputStream input = getAssets().open("im_sdk_configuration.json");
             ByteArrayOutputStream output = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[4096];
            int count;
            while ((count = input.read(buffer)) != -1) {
                if (output.size() + count > 65536) throw new IOException("Configuration too large");
                output.write(buffer, 0, count);
            }
            suppliedConfiguration = object(new JSONObject(new String(output.toByteArray(), StandardCharsets.UTF_8)));
            Object baseUrl = suppliedConfiguration.get("apiBaseUrl");
            Object realm = suppliedConfiguration.get("serviceRealmId");
            if (!(baseUrl instanceof String) || ((String) baseUrl).trim().isEmpty() ||
                !(realm instanceof String) || ((String) realm).trim().isEmpty()) {
                throw new JSONException("Configuration incomplete");
            }
        } catch (IOException | JSONException ignored) {
            suppliedConfiguration = null;
            status.setText("接入方尚未配置聊天服务");
            return;
        }
        consent = new CheckBox(this);
        consent.setText("我已阅读并同意本应用的隐私政策");
        content.addView(consent);
        button(content, "开始聊天", this::openMessenger);
        status.setText("");
    }

    private void openMessenger() {
        if (openingMessenger || suppliedConfiguration == null) return;
        if (!consent.isChecked()) {
            status.setText("请先阅读并同意本应用的隐私政策");
            return;
        }
        openingMessenger = true;
        Map<String, Object> config = new LinkedHashMap<>(suppliedConfiguration);
        config.put("privacyConsentGranted", true);
        config.putIfAbsent("storageNamespace", "native_android_example");
        status.setText("正在连接聊天服务…");
        ImSdk.initialize(this, config, new ImSdk.Callback() {
            @Override public void onSuccess(Object ignored) {
                ImSdk.openMessenger(MainActivity.this, new ImSdk.Callback() {
                    @Override public void onSuccess(Object value) {
                        openingMessenger = false;
                        status.setText("点击开始聊天可继续会话");
                    }
                    @Override public void onError(String code, String message, Object details) {
                        openingMessenger = false;
                        status.setText("暂时无法打开聊天，请稍后重试");
                    }
                });
            }
            @Override public void onError(String code, String message, Object details) {
                openingMessenger = false;
                status.setText("暂时无法连接聊天服务，请稍后重试");
            }
        });
    }

    private void buildDiagnosticsContent(LinearLayout content) {
        TextView title = new TextView(this);
        title.setText("Native IM SDK integration example");
        title.setTextSize(20);
        content.addView(title);
        TextView help = new TextView(this);
        help.setText("Supply your authorized test configuration, credentials and target. No account, message or token is bundled. Input is kept in memory only.");
        content.addView(help);

        configuration = field(content, "Configuration JSON: apiBaseUrl, serviceRealmId; optional gatewayBaseUrl, storageNamespace, locale");
        consent = new CheckBox(this);
        consent.setText("The user has granted the required privacy consent");
        content.addView(consent);
        credentials = field(content, "Credentials JSON: platformUserId, userId, spaceId, accessToken, refreshToken, expiresAt");
        credentials.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD | InputType.TYPE_TEXT_FLAG_MULTI_LINE | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        credentials.setTransformationMethod(PasswordTransformationMethod.getInstance());
        target = field(content, "Direct target JSON: conversationId; or customer-service target JSON: serviceAccountId");

        if (BuildConfig.DEBUG) button(content, "Import private QA input", this::importPrivateQaInput);
        button(content, "1. Initialize", () -> {
            Map<String, Object> config = read(configuration);
            config.put("privacyConsentGranted", consent.isChecked());
            ImSdk.initialize(this, config, callback("Initialized"));
        });
        button(content, "2. Authenticate", () -> ImSdk.authenticate(read(credentials), callback("Authenticated")));
        button(content, "3. Open direct conversation", () -> ImSdk.openDirectConversation(this, read(target), callback("Direct conversation opened")));
        button(content, "3. Open customer service", () -> ImSdk.openCustomerService(this, read(target), callback("Customer service opened")));
        button(content, "Logout", () -> ImSdk.logout(callback("Logged out")));
        button(content, "Shutdown", () -> ImSdk.shutdown(callback("SDK shutdown completed")));

        status.setText("Ready for configuration. This host has no Flutter source dependency.");
        events.setContentDescription("IM SDK event status");
    }

    private EditText field(LinearLayout content, String hint) {
        EditText field = new EditText(this);
        field.setHint(hint);
        field.setMinLines(3);
        field.setMaxLines(6);
        field.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        field.setSaveEnabled(false);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            field.setImportantForAutofill(android.view.View.IMPORTANT_FOR_AUTOFILL_NO_EXCLUDE_DESCENDANTS);
        }
        content.addView(field);
        return field;
    }

    private interface Action { void run() throws JSONException; }

    /** Debug-host input only. This does not initialize, authenticate or invoke the SDK. */
    private void importPrivateQaInput() {
        if (!BuildConfig.DEBUG) return;
        try {
            File directory = getFilesDir().getCanonicalFile();
            File source = new File(directory, "im-sdk-qa-input.json").getCanonicalFile();
            if (!directory.equals(source.getParentFile()) || !source.isFile()) {
                throw new IOException("Private QA input unavailable");
            }
            byte[] data;
            try (FileInputStream input = new FileInputStream(source);
                 ByteArrayOutputStream output = new ByteArrayOutputStream()) {
                byte[] buffer = new byte[4096];
                int count;
                while ((count = input.read(buffer)) != -1) {
                    if (output.size() + count > 65536) throw new IOException("QA input too large");
                    output.write(buffer, 0, count);
                }
                data = output.toByteArray();
            } finally {
                if (!source.delete()) throw new IOException("QA input removal failed");
            }
            JSONObject value = new JSONObject(new String(data, StandardCharsets.UTF_8));
            Iterator<String> keys = value.keys();
            while (keys.hasNext()) {
                String key = keys.next();
                if (!key.equals("configuration") && !key.equals("credentials") &&
                    !key.equals("directTarget") && !key.equals("customerServiceTarget")) {
                    throw new JSONException("Unsupported QA input key");
                }
            }
            JSONObject config = value.getJSONObject("configuration");
            JSONObject identity = value.getJSONObject("credentials");
            JSONObject direct = value.optJSONObject("directTarget");
            JSONObject service = value.optJSONObject("customerServiceTarget");
            if ((direct == null) == (service == null)) throw new JSONException("Supply one target");
            configuration.setText(config.toString());
            credentials.setText(identity.toString());
            target.setText((direct != null ? direct : service).toString());
            status.setText("Private QA input imported. Use the public SDK action buttons.");
        } catch (IOException | JSONException ignored) {
            credentials.getText().clear();
            status.setText("Private QA input unavailable or invalid.");
        }
    }

    private void button(LinearLayout content, String label, Action action) {
        Button button = new Button(this);
        button.setText(label);
        button.setOnClickListener(view -> {
            try { action.run(); }
            catch (JSONException ignored) { status.setText("Enter a valid JSON object in the required input field."); }
        });
        content.addView(button);
    }

    private ImSdk.Callback callback(String success) {
        return new ImSdk.Callback() {
            @Override public void onSuccess(Object ignored) {
                if ("Authenticated".equals(success)) credentials.getText().clear();
                status.setText(success);
            }
            @Override public void onError(String code, String message, Object ignored) {
                // Show only the stable error code; never print returned payloads or credentials.
                status.setText("SDK error: " + code);
            }
        };
    }

    private Map<String, Object> read(EditText field) throws JSONException {
        return object(new JSONObject(field.getText().toString()));
    }

    private Map<String, Object> object(JSONObject json) throws JSONException {
        Map<String, Object> value = new LinkedHashMap<>();
        Iterator<String> keys = json.keys();
        while (keys.hasNext()) {
            String key = keys.next();
            value.put(key, convert(json.get(key)));
        }
        return value;
    }

    private Object convert(Object value) throws JSONException {
        if (value == JSONObject.NULL) return null;
        if (value instanceof JSONObject) return object((JSONObject) value);
        if (value instanceof JSONArray) {
            JSONArray array = (JSONArray) value;
            List<Object> list = new ArrayList<>();
            for (int i = 0; i < array.length(); i++) list.add(convert(array.get(i)));
            return list;
        }
        return value;
    }

    @Override protected void onDestroy() {
        ImSdk.setEventListener(null);
        super.onDestroy();
    }
}
