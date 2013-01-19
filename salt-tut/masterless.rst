Standalone Minion - Salt masterless How to
============================================================

Salt 0.11
----------

Assume that you know how to run salt-master and salt-minion, create states.

You can run salt-minion locally, without a master.

Edit `/etc/salt/minion`::

    file_client: local

then run::

    salt-call state.highstate

Or you can use `--local` option if you did not change your minion config::

    salt-call --local state.highstate

So my best solution is the latter, it no need to change anything.

Read `more` from main doc::

http://salt.readthedocs.org/en/latest/topics/tutorials/standalone_minion.html
