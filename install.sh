flutter build apk --target-platform android-arm64
/root/Android/Sdk/build-tools/30.0.2/apksigner sign --ks /root/github/MoneyTracker/app/sign.jks /root/github/palmmemo/build/app/outputs/flutter-apk/app-release.apk
adb install /root/github/palmmemo/build/app/outputs/flutter-apk/app-release.apk
