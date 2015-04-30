#!/bin/sh


BUNDLE_DIR="JavaScriptNext.tmbundle"
PREFERENCES_DIR="$BUNDLE_DIR/Preferences"
SYNTAXES_DIR="$BUNDLE_DIR/Syntaxes"
THEMES_DIR="$BUNDLE_DIR/Themes"

# build bundle dirs
mkdir -p $PREFERENCES_DIR
mkdir -p $SYNTAXES_DIR
mkdir -p $THEMES_DIR

# copy info.plist
cp info.plist $BUNDLE_DIR/info.plist

# copy preferences
./yaml-to-plist.rb JavaScript\ Indent.YAML-tmPreferences > $PREFERENCES_DIR/JavaScript\ Indent.tmPreferences
./yaml-to-plist.rb Comments.YAML-tmPreferences > $PREFERENCES_DIR/Comments.tmPreferences
./yaml-to-plist.rb Symbol\ List\ Banned.YAML-tmPreferences > $PREFERENCES_DIR/Symbol\ List\ Banned.tmPreferences
./yaml-to-plist.rb Symbol\ List\ Function.YAML-tmPreferences > $PREFERENCES_DIR/Symbol\ List\ Function.tmPreferences

# copy language
./yaml-to-plist.rb JavaScriptNext.YAML-tmLanguage > $SYNTAXES_DIR/JavaScriptNext.tmLanguage
./yaml-to-plist.rb JSON\ \(JavaScriptNext\).YAML-tmLanguage > $SYNTAXES_DIR/JSON\ \(JavaScriptNext\).tmLanguage
./yaml-to-plist.rb Regular\ Expressions\ \(JavaScriptNext\).YAML-tmLanguage > $SYNTAXES_DIR/Regular\ Expressions\ \(JavaScriptNext\).tmLanguage

# copy themes
./yaml-to-plist.rb Next.YAML-tmTheme > $THEMES_DIR/Next.tmTheme
./yaml-to-plist.rb Monokai\ Phoenix.YAML-tmTheme > $THEMES_DIR/Monokai\ Phoenix.tmTheme