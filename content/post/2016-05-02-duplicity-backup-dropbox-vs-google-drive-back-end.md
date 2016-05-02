+++
date = "2016-05-02T14:08:31+02:00"
title = "Duplicity backup: Dropbox vs Google drive back end"
url = "/linux/software/duplicity-backup-dropbox-vs-google-drive-back-end"
tags = ["Duplicity"]
categories = [
"software",
"backup"
]
+++

As many other I have been looking for a cheap encrypted offsite backup for family photos, documents and other important data. I quickly choose duplicity as it provides the encrypted part and the possibility to use many different storage solutions, but the cheap offsite part is was a bit harder to find.<!--more-->

I looked at Amazon offerings: S3 and Glacier, both look cheap, but I'm unsure on how much I have to pay in total, and Glacier has crazy download prices.

My second choice was Dropbox, and I purchased a Dropbox Pro account (1Tb) for EUR 99/year (~ DDK 744/year), but I canceled it after ~8 days, as upload was to slow (Thankfully I could get a refund). It took about ~50 hours to upload ~350Gb. Duplicity uses the [dropbox-python-sdk](https://github.com/dropbox/dropbox-sdk-python/), and Dropbox API's method for uploading files larger than 150Mb is to use "chunked" upload; The first API call creates a session, and then data is append to this session until the entire file is uploaded. The chunk size can be configured, but 150Mb is the max size. So I experimented with different sizes and found that the default size of 16Mb would not utilize the bandwidth very good. But if I changed it to 150Mb I would see ~50Mbps for the entire file, but then would come a delay of 20-30secs where there was no network traffic to Dropbox:

{{< gallery >}}
{{< gallery-photo src="/uploads/duplicity_wan_upload_dropbox_150mb_chunks.png" title="Upload to Dropbox with 150Mb chunk size" thumb="/uploads/thumbnails/duplicity_wan_upload_dropbox_150mb_chunks-176x176.png" no_responsive="true" >}}
{{< gallery-photo src="/uploads/duplicity_wan_upload_dropbox_16mb_chunks.png" title="Upload to Dropbox with 16Mb chunk size" thumb="/uploads/thumbnails/duplicity_wan_upload_dropbox_16mb_chunks-176x176.png" no_responsive="true" >}}
{{< /gallery >}}

I tested the chunk size by changing the DPBX_UPLOAD_CHUNK_SIZE in {{< path >}}/usr/lib/python2.7/site-packages/duplicity/backends/dpbxbackend.py{{< /path >}}:

{{< code python >}}# This is chunk size for upload using Dpbx chumked API v2. It doesn't
# make sense to make it much large since Dpbx SDK uses connection pool
# internally. So multiple chunks will sent using same keep-alive socket
# Plus in case of network problems we most likely will be able to retry
# only failed chunk
DPBX_UPLOAD_CHUNK_SIZE = 16 * 1024 * 1024{{< /code >}}

So I decided to try Google Drive as back end, which was just fixed in duplicity version 0.7.07.1. Google drive utilized the bandwidth much better, and the delay between uploads is when duplicity prepares the next volume for upload.

{{< photo src="/uploads/duplicity_wan_upload_google_drive_volsize_512mb.png" title="Upload to Google Drive with 512Mb volsize" thumb="/uploads/thumbnails/duplicity_wan_upload_google_drive_volsize_512mb-176x176.png" no_responsive="true" >}}

So I purchased 1Tb of storage for Google drive for USD 9.99/month, and to my surprise it was without taxes, so I ended up paying USD 12.49/month (~ DKK 85/month), but it is much faster than Dropbox.

But as duplicity tried to upload the very last file, it encountered an error:

<pre>Attempt 1 failed. OverflowError: length too large
Attempt 2 failed. OverflowError: length too large
Attempt 3 failed. OverflowError: length too large
Attempt 4 failed. OverflowError: length too large
Giving up after 5 attempts. OverflowError: length too large</pre>

It looks like it is caused by [this bug](https://github.com/googledrive/PyDrive/issues/27) in PyDrive. I could see duplicity using more than 70% memory, and then produce an error.

Duplicity creates a "sigtar" file of around 3Gb, which is to much for PyDrive to handle.

<pre>2,9Gb  duplicity-full-signatures.20160425T193345Z.sigtar.gpg
3,1Gb  duplicity-full-signatures.20160425T193345Z.sigtar.part</pre>

The solution is to split the backup into smaller sets, so instead of backing up the entire home directory up, I have one set for documents, one for pictures and so on.

So in conclusion I would say that I found almost every thing I looked for, except the cheap part :)
