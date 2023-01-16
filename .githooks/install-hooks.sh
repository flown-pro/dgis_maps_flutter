#!/bin/sh
# Adds the git-hook described below. Appends to the hook file
# if it already exists or creates the file if it does not.
# Note: CWD must be inside target repository
# Or you can place file pre-commit inside .git/hooks folder manually

HOOK_DIR=$(git rev-parse --show-toplevel)/.git/hooks
HOOK_FILE="$HOOK_DIR"/pre-commit

# Create script file if doesn't exist
if [ ! -e "$HOOK_FILE" ] ; then
        echo '#!/usr/bin/bash' >> "$HOOK_FILE"
        chmod 700 "$HOOK_FILE"
fi

# Append hook code into script
cat >> "$HOOK_FILE" <<EOF

sed -i '' -e 's/applicationId ".*"/applicationId "pro.flown.dgis_maps_flutter_android_example"/' ./dgis_maps_flutter/example/android/app/build.gradle
git add ./dgis_maps_flutter/example/android/app/build.gradle

EOF