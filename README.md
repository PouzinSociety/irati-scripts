Script(s) to be used with IRATI instances

This repository includes IPCM configuration for the various
experiments that were done on rented servers or in developers
environments. They are kept for refence. The repository also include
the *rina* script which was designed to load the configuration
directly from the directories.

**Note that you cannot use this script without a specific branch of
IRATI**


## Quick start

The *rina* script within this directory tries to properly start IPCM
with one of the predefined configuration stored in the repository. It
is independent and can be copied, or simlinked to, in any directory
that is in your $PATH.

## Base configuration

The following environment variables need to be defined when using the
script. For this purpose, the script will look for a file called
*/etc/rina/rina.config* and will source the file as a script.

| Variable | Default paths | Notes |
| ------ | ------ | ------ |
| _RINA_RUNTIME_DIR_ | _/var/run/rina_ | Directory where the console socket, GRPC socket, selected configuration, and PID file are stored |
| _RINA_CONFIG_ROOT_ | _/usr/src/irati-config_ | Directory where the Git repository with the configurations is extracted |
| _RINA_LOG_ROOT_ | _/var/log/rina_ | Directory where IPCM will write its logs files |
| _RINA_IPCM_ | _/usr/local/bin/ipcm_ | Path to the IPCM executable |

### Subcommands

The script supports the following subcommands:

#### start [<config>]

This starts IPCM with the _vlan_ configuration.

```
$ sudo ./rina start vlan

```

The script then will look for a configuration matching the pattern `$(hostname).vlan`. If you do not specificy a configuration name, the script will look for the configuration named *default*.

#### stop


This will stop the running IPCM, whatever the configuration it was
started with. It takes a few seconds for the IPCM to stop.

```
$ sudo ./rina stop
```

### status

This returns the status of the currently running configuration

```
$ sudo ./rina status
```

### console

This starts a _socat_ pointed on the active IPCM console.

```
$ sudo ./rina console
```

### load-modules [<verbose>] / unload-modules

Those command load and unload the IRATI modules. This is generally
done automatically by the *start* and *stop* subcommand but if you
want to make the modules more verbose, you can use the *verbose*
argument to the *load-modules* command and the modules will produce
*abundant* output in the kernel logs.

### Extra commands

The script will transfer any unknown commands to the *irati-ctl*
command, which runs IRATI console commands from the command
line. Provided your system has a Python interpreter, you can then run
commands such as:

```
$ rina list-ipcps
Management Agent not started

Current IPC processes (id | name | type | state | Registered applications | Port-ids of flows provided)
1 | serverN.admin.shim.DIF:1:: | shim-eth | ASSIGNED TO DIF admin.shim.DIF | serverN.admin.DIF-1--| - 
2 | serverN.admin.DIF:1:: | normal-ipc | ASSIGNED TO DIF admin.DIF |  - | - 

$ rina query-rib 2
fgonthier@serverN:~$ sudo rina query-rib 2
Name: ; Class: Root; Instance: 0
Value: -

Name: /difm; Class: DIFManagement; Instance: 1
Value: -

Name: /difm/enr; Class: Enrollment; Instance: 25
Value: -

Name: /difm/enr/neighs; Class: Neighbors; Instance: 26
Value: -

...
```

## Creating a new configuration

You should probably copy the configuration from _vlan.rina1_ to start
with. The name of the directory holding the configuration is separated
in 2 components. One is a descriptive name for the configuration, the
other is the hostname of the host on which this configuration will
apply.

### Special notes about _localConfiguration_

Because of a patch in the _grpc_backend_ branch that allows for
override configuration from the command line, the following
_localConfiguration_ entries in _ipcmanager.conf_ will be __ignored__.

| Configuration |  |
| ------ | ------ |
| _logPath_ | Overridden by the _rina_ script using _RINA_LOG_ROOT_ |
| _consoleSocket_ | Will be created as _ipcm.sock_ in _RINA_RUNTIME_DIR_ |
| _grpcSocket_ | Will be created as _ipcm-grpc.sock_ in _RINA_RUNTIME_DIR_ |
