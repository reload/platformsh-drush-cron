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
docker run --rm -e PROJECT=<platform project ID> -e PLATFORMSH_CLI_TOKEN=<token> ghcr.io/reload/platform-drush-cron:latest <platform project ID>
```

That will run `platform drush cron` on all environments of the project
with the ID `<platform project ID>`.

If you don't want to run it on all activated environments you can add
a space separated list of environments in the `ENVIRONMENTS`
environment variable.

## Running something else instead of `cron`

You can actually run another Drush command instead of `cron`. This is
useful if you use [Ultimate
Cron](https://www.drupal.org/project/ultimate_cron) on an old Drupal 7
site and need to use `cron-run` instead of `cron`.

Just set the environment variable `ARGUMENTS` to i.e. `cron-run`.

Or if you wanted to run a queue you could use `queue:run my-queue` as `ARGUMENTS`.

## Running something else instead of `drush`

If you want to run another `platform` CLI command instead of `drush`
you have to set the environment variable `COMMAND`.

## Run the command using systemd services and timers

Here is an example of running it every minute using a systemd service
and timer where we pass the API token and project ID in a environment
file name after the instance name to a systemd template unit.

`platformsh-drush-cron@.service`:

```ini
[Unit]
Description=Run Platform.sh cron for project %i

[Service]
Type=oneshot
ExecStart=/usr/bin/docker run --rm --env-file "%h/platformsh-drush-cron/config/%i.env" ghcr.io/reload/platformsh-drush-cron:latest
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
