```bash
./gen-mytardis_version.sh > settings.d/MYTARDIS_VERSION.py
sed -i 's;image: monashmerc/mytardis_django:.*$;image: monashmerc/mytardis_django:4.0-RC10;' docker-compose.yml
docker-compose build
docker login
docker tag monashmerc/mytardis_django:4.0-RC10 monashmerc/mytardis_django:latest
docker push monashmerc/mytardis_django:4.0-RC10
docker push monashmerc/mytardis_django:latest
docker logout
```
