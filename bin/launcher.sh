#!/bin/bash
# launcher.sh - Launches OpenAudible with user.home set to the parent
# of whatever directory launcher.sh is in.
#
# Brian K. White b.kenyon.w@gmail.com
#
# This is to work around some missing configurability in OpenAudible

################################################################################
# THE PROBLEM(s)
#
# * Normally, if you specify "Web/MP3" and "Working" paths in Preferences to an
#   external drive, the integrated browser still downloads *.part files to
#   <user.home>/OpenAudible/tmp, and then it fails to move the finished *.part
#   file to the final *.aax filename, because the source and destination paths
#   are on different filesystems. The app must be using a java equivalent
#   of simple rename() to move the file, which only works within a single
#   filesystem, which is a broken assumption.
#
# * The base directory where ./OpenAudible/tmp/*.part will be created,
#   is not configurable within the app. So you can't set it to be on the same
#   external drive as the "Web/MP3" or "Working" preferences.
#
# * The path to the app configuration/settings files is not configurable,
#   and is hard coded in the app to be <user.home>/OpenAudible. This means you
#   can't have multiple Audible accounts.

################################################################################
# THE WORK-AROUND
#
# OpenAudible is a java app, and -Duser.home=/some/other/path actually
# works and changes the path that OpenAudible works out of.
# So that's what this script does.
#
# The fake user.home is determined dynamically by getting the parent of the
# script dir. This way you can move the OpenAudible directory to another drive
# or anywhere you want, without having to edit anything in this script.
#
# You can run the script manually or click on it in the desktop file manager,
# and it will cause OpenAudible to essentially work like a portable app working
# out of whatever dir it's sitting in. The entire app is not actually portable,
# just your data. The app itself still lives in /opt/OpenAudible.
#
# This allows 2 main things:
#
# * All data, config settings, downloaded aax files, comverted mp3 files, web
#   temp files, ALL live in whatever dir you want, including an external drive
#   or network share.
#
# * You can have multiple data sets side by side, each with their own config
#   files, so you can use more than a single Audible.com account.

################################################################################
# DIRECTIONS
#
# If you already have a populated ~/OpenAudible directory that you want to move
# to a new location:
#   * Move your OpenAudible dir wherever you want.
#   * Delete directories.json
#
# If you have no ~/OpenAudible dir yet, create a directory named OpenAudible
# wherever you want.
#
# Copy this script (launcher.sh) to the new OpenAudible dir, IE:
# /path/to/OpenAudible/launcher.sh
#
# Copy OpenAudible.desktop from /usr/share/applications to your
# ~/.local/share/applications
#
# Edit ~/.local/share/applications to use Exec=/path/to/OpenAudible/launcher.sh
#
# Optional: Delete /usr/share/applications/OpenAudible.desktop, so that only
# one OpenAudible icon appears in your start menu, and you can be sure it's the
# new one that won't try to create files in $HOME again.
#
# May need to log out & in to get the new .desktop file in your desktop menus.

################################################################################
# TODOS
#
# Examine directories.json ourselves and delete it or rename it
# automatically on the fly if BASE doesn't match ourself.
#
# Generate *.desktop file for ourself.
#
# Detect if $0 is a symlink and resolve the real path.
#
# Safety/sanity checks: Handle weirdball cases like $0 is right in "/",
# or in a top level dir in /, etc.
#
# Zenity menu to select from several datasets, so you can have multiple
# Amazon/Audible accounts.
#
# Single central launcher that gets the base dir from env set in .profile
# that way we don't need a custom user *.desktop file.
#
# Single central launcher pops up a zenity message if the base path does
# not exist (usb drive not connected, nas share not mounted, etc), instead of
# just nothing happens at all when you click the *.desktop file.

x="${0%/*}"
x="${x%/*}"
export _JAVA_OPTIONS=-Duser.home="${x}"

/opt/OpenAudible/OpenAudible
