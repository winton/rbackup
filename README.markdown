rbackup
=======

Backup your stuff with Ruby and Rsync.

Setup
-----

<pre>
gem sources -a http://gems.github.com
sudo gem install winton-rbackup
</pre>

Create ~/.rbackup.yml
---------------------

<pre>
site:
  server:
    source: /Users/me/site
    destination: deploy@server:/var/www
    exclude:
     - .git
     - /site/config/database.yml
usb:
  documents:
    source: ~/Documents
    destination: /Volumes/USB Key
    exclude:
     - Software
     - Virtual Machines.localized
  pictures:
    source: ~/Pictures
    destination: /Volumes/USB Key
    include:
      - Favorites
</pre>

Backup
------

<pre>
rbackup site
  // deploys your site
rbackup usb
  // back up documents and pictures
rbackup documents
  // back up documents only
rbackup
  // back up and deploy everything
</pre>