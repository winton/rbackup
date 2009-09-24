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
</pre>

Backup
------

<pre>
rbackup documents
	// backs up documents
rbackup usb
	// backs up documents and pictures
rbackup
	// backs up all profiles
</pre>