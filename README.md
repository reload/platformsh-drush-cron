# Platform.sh Drush command wrapper

This is wrapper for executing `platform drush cron` on all activated
environments.

On Platform.sh cron jobs can only be executed every five minutes (with
a sliding window of five minutes as well).

This is sufficient on most sites. A few sites demand cron to run
_every_ minute, though. In our case this is usually to control
scheduled publishing at the exact minute.

You can use this wrapper to execute `platform drush cron` using some
other servers cron or systemd timers.

As an added bonus the wrapper will run `platform drush cron` on all
your activated environments. This let's you test minute-based,
scheduled publishing on Pull Request-environments as well.

## How to use

Let's start out simply by running the command once:

```console
docker run -it --rm -v "$PWD/config:/config" reload/platform-drush-cron:latest <platform project ID>
```

That will run `platform drush cron` on all environments of the project
with the ID `<platform project ID>`.

But we cheated a bit. We need to authenticate using an API token
first:

```console
$ docker run -it --rm -v "$PWD/config:/config" --entrypoint=api-token-login reload/platform-drush-cron:latest
Please enter an API token:
>

The API token is valid.
You are logged in.

Generating SSH certificate...
A new SSH certificate has been generated.
It will be automatically refreshed when necessary.
Do you want to create an SSH configuration file automatically? [Y/n]
Configuration file created successfully: /config/.ssh/config

Username: <user>
Email address: <mail@example.com>
```

Also you better run it manually the first time. You have to accept SSH
server host keys:

```console
$ docker run -it --rm -v "$PWD/config:/config:z" reload/platformsh-drush-cron:latest <platform project ID>
The authenticity of host 'ssh.eu-2.platform.sh (34.248.104.12)' can't be established.
RSA key fingerprint is SHA256:YuC5lv0dMBN4tOZLIUBLDDT0ZIWyyaVfeDrCcrEH1Sw.
Are you sure you want to continue connecting (yes/no)? yes
```

The mounted volume is used for storing API-token and SSH host keys.

## Running something else instead of `cron`

You can actually run another Drush command instead of `cron`. This is
useful if you use [Ultimate
Cron](https://www.drupal.org/project/ultimate_cron) on an old Drupal 7
site and need to use `cron-run` instead of `cron`. Extend the project
ID with a colon and the name of the command:

```console
docker run -it --rm -v "$PWD/config:/config:z" reload/platformsh-drush-cron:latest <platform project ID>:cron-run
```

## Run the command using systemd services and timers

Here is an example of running it every minute using a systemd service
and timer where we pass the project ID as an instance name to a
systemd template unit.

`platformsh-drush-cron@.service`:

```ini
[Unit]
Description=Run Platform.sh cron for project %i

[Service]
Type=oneshot
ExecStart=/usr/bin/docker run --rm -v "%h/platformsh-drush-cron/config:/config:z" reload/platformsh-drush-cron:latest %i
```

`platformsh-drush-cron@.timer`:

```ini
[Unit]
Description=Run Platform.sh cron for project %i every minute

[Timer]
OnCalendar=minutely
AccuracySec=1us

[Install]
WantedBy=timers.target
```
