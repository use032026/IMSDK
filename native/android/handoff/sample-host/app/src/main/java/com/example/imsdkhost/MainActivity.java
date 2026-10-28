package com.example.imsdkhost;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Insets;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.WindowInsets;
import android.view.WindowInsetsController;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import com.imsdk.nativebridge.ImSdk;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/** Native Java consumer. SDK owns login, contacts, direct and group messages. */
public final class MainActivity extends Activity {
    private final Map<String, Object> configuration = new LinkedHashMap<>();
    private CheckBox consent;
    private TextView status;
    private TextView eventStatus;
    private Uri privacyPolicy;
    private boolean busy;
    private boolean configured;

    @Override public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ScrollView scroll = new ScrollView(this);
        LinearLayout content = new LinearLayout(this);
        content.setOrientation(LinearLayout.VERTICAL);
        int spacing = (int) (20 * getResources().getDisplayMetrics().density);
        content.setPadding(spacing, spacing, spacing, spacing);
        scroll.addView(content);
        setContentView(scroll);
        applySystemInsets(scroll);
        loadConfiguration();
        TextView help = new TextView(this);
        help.setText("配置聊天服务后，阅读本应用的隐私政策并同意，即可进入账号登录、单聊和群聊。");
        content.addView(help);
        button(content, "阅读隐私政策", this::readPrivacyPolicy);
        consent = new CheckBox(this);
        consent.setText("我已阅读并同意本应用的隐私政策");
        consent.setChecked(false);
        consent.setEnabled(privacyPolicy != null);
        content.addView(consent);
        button(content, "开始聊天", this::openMessenger);
        button(content, "退出 IM 账号", () -> {
            if (busy) return;
            busy = true;
            ImSdk.logout(callback("IM 账号已退出。"));
        });
        button(content, "释放 SDK 资源", () -> {
            if (busy) return;
            busy = true;
            ImSdk.shutdown(callback("SDK 资源已释放。"));
        });
        status = new TextView(this);
        status.setText(configured ? "请先阅读隐私政策并同意。" :
            "请在 assets/im_sdk_configuration.json 填写服务配置及隐私政策 HTTPS 地址。");
        content.addView(status);
        eventStatus = new TextView(this);
        content.addView(eventStatus);
        // Never display full event payloads, user identities, messages or tokens.
        ImSdk.setEventListener(event -> {
            Object type = event.get("type");
            eventStatus.setText("SDK 事件：" + (type instanceof String ? type : "event"));
        });
    }

    private void applySystemInsets(ScrollView scroll) {
        scroll.setBackgroundColor(Color.WHITE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            getWindow().setDecorFitsSystemWindows(false);
            WindowInsetsController controller = getWindow().getInsetsController();
            if (controller != null) controller.setSystemBarsAppearance(
                WindowInsetsController.APPEARANCE_LIGHT_STATUS_BARS |
                WindowInsetsController.APPEARANCE_LIGHT_NAVIGATION_BARS,
                WindowInsetsController.APPEARANCE_LIGHT_STATUS_BARS |
                WindowInsetsController.APPEARANCE_LIGHT_NAVIGATION_BARS);
        } else {
            getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
                View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
        }
        getWindow().setStatusBarColor(Color.TRANSPARENT);
        scroll.setOnApplyWindowInsetsListener((view, insets) -> {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                Insets safe = insets.getInsets(WindowInsets.Type.systemBars() | WindowInsets.Type.displayCutout());
                view.setPadding(safe.left, safe.top, safe.right, safe.bottom);
            } else {
                view.setPadding(insets.getSystemWindowInsetLeft(), insets.getSystemWindowInsetTop(),
                    insets.getSystemWindowInsetRight(), insets.getSystemWindowInsetBottom());
            }
            return insets;
        });
        scroll.requestApplyInsets();
    }

    private void loadConfiguration() {
        try (InputStream input = getAssets().open("im_sdk_configuration.json");
             ByteArrayOutputStream output = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[4096];
            int count;
            while ((count = input.read(buffer)) != -1) {
                if (output.size() + count > 65536) throw new IOException("Configuration too large");
                output.write(buffer, 0, count);
            }
            configuration.putAll(object(new JSONObject(new String(output.toByteArray(), StandardCharsets.UTF_8))));
            Object policy = configuration.remove("hostPrivacyPolicyUrl");
            if (policy instanceof String && isHttps((String) policy)) privacyPolicy = Uri.parse((String) policy);
            configuration.remove("privacyConsentGranted");
            Object api = configuration.get("apiBaseUrl");
            Object realm = configuration.get("serviceRealmId");
            configured = api instanceof String && isHttps((String) api) && realm instanceof String &&
                !((String) realm).trim().isEmpty() && privacyPolicy != null;
        } catch (IOException | JSONException ignored) {
            configuration.clear();
            configured = false;
        }
    }

    private static boolean isHttps(String value) {
        Uri uri = Uri.parse(value);
        return "https".equalsIgnoreCase(uri.getScheme()) && uri.getHost() != null && !uri.getHost().isEmpty();
    }

    private void readPrivacyPolicy() {
        if (privacyPolicy == null) {
            status.setText("请先配置本应用真实的隐私政策 HTTPS 地址。");
            return;
        }
        try {
            startActivity(new Intent(Intent.ACTION_VIEW, privacyPolicy));
        } catch (ActivityNotFoundException ignored) {
            status.setText("无法打开浏览器，请先安装浏览器后阅读隐私政策。");
        }
    }

    private void openMessenger() {
        if (busy) return;
        if (!configured) {
            status.setText("请先填写 assets/im_sdk_configuration.json。");
            return;
        }
        if (!consent.isChecked()) {
            status.setText("请先阅读并同意本应用的隐私政策。");
            return;
        }
        busy = true;
        status.setText("正在连接聊天服务…");
        Map<String, Object> input = new LinkedHashMap<>(configuration);
        input.put("privacyConsentGranted", true);
        ImSdk.initialize(this, input, new ImSdk.Callback() {
            @Override public void onSuccess(Object ignored) {
                if (isFinishing() || isDestroyed()) { busy = false; return; }
                ImSdk.openMessenger(MainActivity.this, callback("已打开聊天，关闭页面后可再次进入。"));
            }
            @Override public void onError(String code, String message, Object details) {
                finishOperation("操作未完成（" + code + "）。");
            }
        });
    }

    private ImSdk.Callback callback(String success) {
        return new ImSdk.Callback() {
            @Override public void onSuccess(Object ignored) { finishOperation(success); }
            @Override public void onError(String code, String message, Object details) {
                // Do not render server details or log sensitive data.
                finishOperation("操作未完成（" + code + "）。");
            }
        };
    }

    private void finishOperation(String message) {
        busy = false;
        if (!isFinishing() && !isDestroyed()) status.setText(message);
    }

    private void button(LinearLayout parent, String label, Runnable action) {
        Button button = new Button(this);
        button.setText(label);
        button.setOnClickListener(view -> action.run());
        parent.addView(button);
    }

    private static Map<String, Object> object(JSONObject json) throws JSONException {
        Map<String, Object> result = new LinkedHashMap<>();
        Iterator<String> keys = json.keys();
        while (keys.hasNext()) {
            String key = keys.next();
            result.put(key, value(json.get(key)));
        }
        return result;
    }

    private static Object value(Object value) throws JSONException {
        if (value == JSONObject.NULL) return null;
        if (value instanceof JSONObject) return object((JSONObject) value);
        if (value instanceof JSONArray) {
            JSONArray array = (JSONArray) value;
            List<Object> result = new ArrayList<>();
            for (int i = 0; i < array.length(); i++) result.add(value(array.get(i)));
            return result;
        }
        return value;
    }

    @Override protected void onDestroy() {
        // Page close can keep the SDK engine/session alive. Release it explicitly
        // with shutdown when the host no longer needs the SDK, not on rotation.
        ImSdk.setEventListener(null);
        super.onDestroy();
    }
}
