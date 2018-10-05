# docker-mytardis

# Deployment - Docker compose

```
$ git clone --recursive https://github.com/monash-merc/docker-mytardis.git mytardis
$ cd mytardis
```

The `--recursive` option is required to pull in the the MyTardis git submodule.

If using the default `mytardis-4.x` branch of the `monash-merc/docker-mytardis` repository,
this will pull all the MyTardis series-4.0 branch source and set docker-compose.yml file for
the latest monashmerc/mytardis\_django docker image (based on UWA's uwaedu/mytardis\_django
MyTardis docker image) with prerequisites for testing, etc...

To contribute to the MyTardis project please read the [CONTRIBUTING.rst](https://github.com/mytardis/mytardis/blob/master/CONTRIBUTING.rst).

## General instructions

* Rename each required env\_template.MODULE file removing the "\_template" from the name.
  * Database settings are essential, so you will require `env.POSTGRES` or an equivalent
    for your preferred database engine.
  * Django email settings (configured in `env.DJANGO_EMAIL`) are essential for running MyTardis
    in production (with Django's DEBUG set to False), because unhandled exceptions will be
    emailed to the MyTardis server administrators.
* If you don't require the functionality configured by one or more of these env files, then you
    don't need to rename it, but you should check whether it is referenced in any of the
    `env_file:` sections of your `docker-compose.yml` file and remove any references to it.
* The `Dockerfile` can be used with `docker-compose build` to build the
    `monashmerc/mytardis_django` image which is referenced from within the `docker-compose.yml`
     file.
    * You may need to build your own version of the `monashmerc/mytardis_django` image if
      you need to customize MyTardis's source code, but running `docker-compose` can pull
      a pre-built `monashmerc/mytardis_django` image from DockerHub.

Edit `Dockerfile` and/or `docker-compose.yml` to your desired settings / alterations.

```
$ docker-compose pull                  # acquire the latest image from DockerHub
$ docker-compose up -d                 # start docker containers
$ docker-compose logs --no-color -f    # check logging output

(wait for logging output to stop, usually after a group of lines like this, then interrupt with Ctrl-C:)

        django_1    | [2018-02-26 04:37:36 +0000] [106] [INFO] Booting worker with pid: 106
        django_1    | [2018-02-26 04:37:36 +0000] [111] [INFO] Booting worker with pid: 111
        django_1    | [2018-02-26 04:37:36 +0000] [114] [INFO] Booting worker with pid: 114

$ docker-compose exec django python mytardis.py createsuperuser
```

Once the startup process has completed point you browser to http://localhost:8080/ and login
using the credentials provided to the createsuperuser script above.

This development uses [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to incorporate other code bases into the build process were appropriate, such as the MyTardis source. To work on a different upstream version you should follow "Working on a Project with Submodules", "Pulling in Upstream Changes". E.g.,

```
To pull the latest upstream changes from MyTardis.
From the cloned project directory run
$ cd src/mytardis
$ git fetch
$ git merge origin/master
$ cd ../..
$ docker-compose build
```

# Configuration

Configuration can be accomplished in a number of different was as circumstance dictates.

## Docker build settings

* Dockerfile
* docker-entrypoint.d/

  Processed in the Django containers.

  Dump directory for Docker entrypoint bash scripts.

  The scripts are executed in the startup shell (not spawned) and are processed in lexical order.

* docker-entrypoint\_celery.d/

  Processed in the Celery containers.

  Dump directory for Docker entrypoint bash scripts.

  The scripts are executed in the startup shell (not spawned) and are processed in lexical order.

* settings.d/

  Django settings dump directory.

## Docker compose image instantiation settings

* docker-compose.yml
  * env.MODULE

    Entries to these are placed in the docker-compose.yml file [env_file](https://docs.docker.com/compose/environment-variables/#the-env_file-configuration-option) and allow environment settings for container instances/deployments.

    env_template.MODULE templates are provided for examples and reference. Alter the settings for your deployment and rename the files to env.MODULE (remove the _template part of the name).

# References

## Ref. Source

[MyTardis](https://github.com/mytardis/mytardis)

## Ref. Docker

[Django docker container](https://github.com/GoHiTech/docker-django)

