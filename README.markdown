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
documents:
  source: ~/Documents
  destination: /Volumes/USB Key
  exclude:
	 - Software
	 - Virtual Machines.localized
</pre>

Backup
------

<pre>
rbackup documents
</pre>