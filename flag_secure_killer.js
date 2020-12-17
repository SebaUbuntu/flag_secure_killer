// Source: https://www.securify.nl/blog/android-frida-hooking-disabling-flagsecure
Java.perform(function () {
    // https://developer.android.com/reference/android/view/WindowManager.LayoutParams.html#FLAG_SECURE
    var FLAG_SECURE = 0x2000;
    var Window = Java.use("android.view.Window");
    var setFlags = Window.setFlags; //.overload("int", "int")

    setFlags.implementation = function (flags, mask) {
        console.log("Disabling FLAG_SECURE...");
        flags &= ~FLAG_SECURE;
        setFlags.call(this, flags, mask);
        // Since setFlags returns void, we don't need to return anything
    };
});
    