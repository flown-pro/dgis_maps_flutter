#!/bin/sh
# Adds the git-hook described below. Appends to the hook file
# if it already exists or creates the file if it does not.
# Note: CWD must be inside target repository
# Or you can place file pre-commit inside .git/hooks folder manually

HOOK_DIR=$(git rev-parse --show-toplevel)/.git/hooks
HOOK_FILE="$HOOK_DIR"/pre-commit

# Create script file if doesn't exist
if [ ! -e "$HOOK_FILE" ] ; then
        echo '#!/bin/bash' >> "$HOOK_FILE"
        chmod 700 "$HOOK_FILE"
fi

# Append hook code into script
cat >> "$HOOK_FILE" <<EOF

### ./example/android/app/build.gradle

cp ./example/android/app/build.gradle ./example/android/app/build.gradle.bak
sed -i '' -e 's/applicationId ".*"/applicationId "pro.flown.dgis_maps_flutter_android_example"/' ./example/android/app/build.gradle
git add ./example/android/app/build.gradle
mv ./example/android/app/build.gradle.bak ./example/android/app/build.gradle


### ./example/ios/Runner.xcodeproj/project.pbxproj

cp ./example/ios/Runner.xcodeproj/project.pbxproj ./example/ios/Runner.xcodeproj/project.pbxproj.bak
sed -i '' -e 's/PRODUCT_BUNDLE_IDENTIFIER = .*;/PRODUCT_BUNDLE_IDENTIFIER = pro.flown.dgis_maps_flutter_example;/g' ./example/ios/Runner.xcodeproj/project.pbxproj
git add ./example/ios/Runner.xcodeproj/project.pbxproj
mv ./example/ios/Runner.xcodeproj/project.pbxproj.bak ./example/ios/Runner.xcodeproj/project.pbxproj

EOF