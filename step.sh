#!/bin/bash

#test
# exit if a command fails
set -e

#
# Required parameters
if [ -z "${info_plist_file}" ] ; then
  echo " [!] Missing required input: info_plist_file"
  exit 1
fi
if [ ! -f "${info_plist_file}" ] ; then
  echo " [!] File Info.plist doesn't exist at specified path: ${info_plist_file}"
  exit 1
fi

if [ -z "${custom_key}" ] ; then
  echo " No Key (custom_key) specified"
  exit 1
fi

if [ -z "${custom_key_value}" ] ; then
  echo " No key value specified"
  exit 1
fi

# ---------------------
# --- Configs:

echo " (i) Provided Info.plist file path              : ${info_plist_file}"
echo " (i) Provided Key                               : ${custom_key}"
echo " (i) Provided Value                             : ${custom_key_value}"
# ---------------------
# --- Main:

# verbose / debug print commands
#set -v

function setPlistValue() {
  # ---- Set Info.plist value:
  echo ""
  echo ""
  echo " (i) Replacing $1..."

  ORIGINAL_VALUE="$(/usr/libexec/PlistBuddy -c "Print :$2" "$3")"
  echo " (i) Original Value: $ORIGINAL_VALUE"

  /usr/libexec/PlistBuddy -c "Set :$2 $4" "$3"

  REPLACED_VALUE="$(/usr/libexec/PlistBuddy -c "Print :$2" "$3")"
  echo " (i) Replaced Value: $REPLACED_VALUE"

  # ==> Value patched in Info.plist file for iOS project
}

if [ -n "${custom_key}" ] ; then
  setPlistValue "${custom_key}" "${custom_key}" "${info_plist_file}" "${custom_key_value}"
else
  echo " (i) Not setting Bundle Identifier"
fi