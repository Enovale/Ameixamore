package com.enova.ameixamore.activities;

import android.content.res.Configuration;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.LinearLayout;

import com.enova.ameixamore.R;
import com.enova.ameixamore.utils.IntentUtils;
import com.enova.ameixamore.views.CenterButton;

public class MainActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        createLayout();
    }

    private void createLayout() {
        LinearLayout frameLayout = new LinearLayout(this);
        frameLayout.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT));
        int nightModeFlags = getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK;
        frameLayout.setBackgroundColor(getResources().getColor(nightModeFlags == Configuration.UI_MODE_NIGHT_YES ? R.color.colorDark : R.color.colorLight));
        frameLayout.setGravity(Gravity.CENTER);
        setContentView(frameLayout);

        LinearLayout baseLayout = new LinearLayout(this);
        baseLayout.setOrientation(LinearLayout.VERTICAL);
        baseLayout.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.MATCH_PARENT));
        baseLayout.setGravity(Gravity.START);
        frameLayout.addView(baseLayout);

        CenterButton icons = new CenterButton(this);
        icons.setText(R.string.icons);
        icons.setIcon(R.drawable.ic_icons);
        icons.setOnClickListener(v -> IntentUtils.openActivity(this, IconActivity.class));
        baseLayout.addView(icons);

        CenterButton source = new CenterButton(this);
        source.setText(R.string.source);
        source.setIcon(R.drawable.ic_code);
        source.setOnClickListener(v -> IntentUtils.openUrl(this, R.string.url_repository));
        baseLayout.addView(source);

        CenterButton code = new CenterButton(this);
        code.setText(R.string.license);
        code.setIcon(R.drawable.ic_copyright);
        code.setOnClickListener(v -> IntentUtils.openActivity(this, LicenseActivity.class));
        baseLayout.addView(code);
    }
}
