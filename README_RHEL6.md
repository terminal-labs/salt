## RHEL 6

This is a branch of v3005.1 of Open Salt that has a custom script to install Salt on a RHEL / Cent 6 machine.

## Installation of Salt

### Assumptions

The target machine is assumed

- to have access to the internet, such that updating and installing packages is possible
- to have `git` installed, so that this fork can be cloned and the correct commit checked out
- to have sufficient drive space, RAM, available cycles, etc
- to have a non-root user that has passwordless `sudo` priveledges run the installation script

### Install Prep

As a user on the target system with sudo priveleges, prepare the machine by creating the appropriate target dir and cloning this fork of Salt:

```bash
sudo mkdir -p /opt/salt
sudo chown $USER:$USER /opt/salt
cd /opt/salt
git clone https://github.com/terminal-labs/salt.git /opt/salt
git checkout rhel6
```

### Installation

Now with this fork cloned, run the installation script.

```bash
cd /opt/salt/
./rhel6_install.sh
```

This will download and install all needed dependencies, including compiling Python 3.6, and install Salt from this checked out commit. All the usual Salt binaries will be exposed to the root user, and the following binaries have been tested: `salt`, `salt-master`, and `salt-minion`.

If for some reason the root user doesn't have it's `PATH` correctly set, it is helpful to know that these binaries live at `/opt/salt/saltenv/bin` and can be called from that location. This is the same `PATH` that also contains the binaries for Python 3.6 and the correct `pip`.

### Configuration

The usual configuration files and directories will exist in `/etc/salt`. It is advised that a minion configuration file be added to make any changes needed. To do this, add the file in `/etc/salt/minion.d/minion.conf` with any configuration needed, for example:

```conf
# /etc/salt/minion.d/minion.conf

# master ip / fqdn
master: 1.2.3.4
```

## Running the Salt Minion

With the installation and configuration complete, the salt minion can be ran from the terminal with the `salt-minion` binary. For example, as the root user

```bash
salt-minion -d
```

will run the Salt minion as a daemon.

Or, you can use `service` to control the Salt minion.

```bash
service salt-minion start
```

likewise, the Salt minion service also has available the `status`, `stop`, and `restart` subcomands.

### Starting on boot

This installation configures the Salt minion to start on boot with `chkconfig`.
