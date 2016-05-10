+++
date = "2016-05-10T10:40:15+02:00"
title = "Backing up to Google drive with Duplicity"
url = "/linux/software/backing-up-to-google-drive-with-duplicity"
tags = ["Duplicity"]
categories = [
"software",
"backup"
]
+++

As described in my [previous post](/linux/software/duplicity-backup-dropbox-vs-google-drive-back-end/) I use Duplicity with Google Drive for storage. In this post I give a quick how to on configuring Duplicity for that setup.<!--more-->

## Prerequisites

* Duplicity installed
* PyDrive, I installed it from Arch Linux's [Aur repository](https://aur.archlinux.org/packages/python2-pydrive/)
* GPG keys configured
* A Google Drive account
* First time you run Duplicity it has to be done interactively, as it will prompt you to allow access to Google drive

## Google drive API setup

Go to [console.developers.google.com](https://console.developers.google.com/) and create a new project, under "Show advanced options > App Engine location" I selected "europe-west".

1. Select "Google Drive API" and enable, then select "Credentials" in the menu to the left
2. Fill out "OAuth consent screen"
3. Click "Create credentials" in the popup and select "OAuth client ID" in the dropdown
4. Select "Other" and give the client a name
5. Download the JSON file, save it as {{< path >}}/root/.duplicity/client_secrets.json{{< /path >}}. Put the "Client ID" and "Client secret" in {{< path >}}/root/.duplicity/gdrive{{< /path >}} (see below)

{{< gallery >}}
{{< gallery-photo src="/uploads/duplicity_gdrive_backend_api_enable_api.png" title="1. Enabling Google drive API for project" thumb="/uploads/thumbnails/duplicity_gdrive_backend_api_enable_api.png" >}}
{{< gallery-photo src="/uploads/duplicity_gdrive_backend_api_oauth_consent_screen.png" title="2. OAuth consent screen" thumb="/uploads/thumbnails/duplicity_gdrive_backend_api_oauth_consent_screen.png" >}}
{{< gallery-photo src="/uploads/duplicity_gdrive_backend_api_create_oauth.png" title="3. Selecting OAuth client ID" thumb="/uploads/thumbnails/duplicity_gdrive_backend_api_create_oauth.png" >}}
{{< gallery-photo src="/uploads/duplicity_gdrive_backend_api_create_client_id.png" title="4. Creating client ID" thumb="/uploads/thumbnails/duplicity_gdrive_backend_api_create_client_id.png" >}}
{{< gallery-photo src="/uploads/duplicity_gdrive_backend_api_client_id.png" title="5. Credentials for client and JSON download" thumb="/uploads/thumbnails/duplicity_gdrive_backend_api_client_id.png" >}}
{{< /gallery >}}

Create {{< path >}}/root/.duplicity/gdrive{{< /path >}} and add the values from step 5:

{{< code yml >}}client_config_backend: settings
client_config:
  client_id: XXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com
  client_secret: XXXXXXXXXXXXXXXXXXXXXX
save_credentials: True
save_credentials_backend: file
save_credentials_file: gdrive.cache
get_refresh_token: True{{< /code >}}

## Granting Duplicity access to Google drive

PyDrive would prompt for a verification code everytime I ran Duplicity, and would not create the gdrive.cache file. I fixed it by changing the current working directory to {{< path >}}/root/.duplicity/{{< /path >}}. A simple script like the following should work:

{{< code bash >}}#!/bin/bash
cd /root/.duplicity/

PASSPHRASE="XXXXXXXXXX"
GOOGLE_DRIVE_SETTINGS="/root/.duplicity/gdrive"
DEST="gdocs://YOUR_GMAIL/SOME_DIR/$HOSTNAME/home"
SRC="/home"

duplicity incr --encrypt-key XXXXXXX --full-if-older-than 4M --volsize 1024 --asynchronous-upload --exclude-device-files --exclude-other-filesystems "${SRC}" "${DEST}"{{< /code >}}

When you run this script the first time, you should get a prompt that says (XXXXXXXXXXXXXXXXXXXXXX will be your client id):

<pre>Go to the following link in your browser:

    https://accounts.google.com/o/oauth2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&client_id=XXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com&access_type=offline

Enter verification code:</pre>

When you have approved access you should have the file {{< path >}}/root/.duplicity/gdrive.cache{{< /path >}}, and next time Duplicity runs, it should automatically be authorized.

## Wrapping up

I have created a set of [Duplicity backup scrips](https://github.com/henrik-farre/duplicity_backup_scripts) with error handling/reporting that wraps backup, restore, cleanup and backup verification, feel free to use or fork them :)
