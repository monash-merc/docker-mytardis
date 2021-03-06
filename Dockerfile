FROM monashmerc/django:dj1.11
MAINTAINER Dean Taylor <dean.taylor@uwa.edu.au>

ENV DJANGO_PROJECT_NAME="tardis"

RUN apt-get update && apt-get -y install \
  libfreetype6-dev \
  libjpeg-dev \
  libldap2-dev \
  libsasl2-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  zlib1g-dev \
  && apt-get clean

RUN pip install --upgrade --no-cache-dir \
  pip

RUN pip install --no-cache-dir \
  anyjson==0.3.3 \
  beautifulsoup4==4.6.0 \
  feedparser==5.2.1 \
  flexmock==0.10.2 \
  html5lib==0.999999999 \
  httplib2==0.10.3 \
  ipython==2.4.1 \
  pycrypto==2.6.1 \
  pystache==0.5.4 \
  python-dateutil==2.6.1 \
  PyYAML==3.12 \
  Wand==0.4.4

COPY src/mytardis/tardis/ tardis/
COPY src/mytardis/wsgi.py tardis/
COPY src/mytardis/manage.py ./
COPY src/mytardis/test.py ./

# For pylint:
COPY src/mytardis/.pylintrc ./

# For npm install and npm test:
COPY src/mytardis/package.json ./
COPY src/mytardis/.eslint* ./
COPY src/mytardis/Gruntfile.js ./
COPY src/mytardis/js_tests/ js_tests/
# For behave test:
RUN apt-get update && apt-get install \
    -qy \
    unzip \
    openjdk-8-jre-headless \
    xvfb \
    libxi6 \
    libgconf-2-4 \
    wget
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -qy google-chrome-stable
RUN wget -N http://chromedriver.storage.googleapis.com/2.40/chromedriver_linux64.zip -P ~/
RUN unzip ~/chromedriver_linux64.zip -d ~/
RUN mv -f ~/chromedriver /usr/local/bin/chromedriver
ENV PATH="/usr/local/bin:${PATH}"
RUN chmod 0755 /usr/local/bin/chromedriver
COPY src/mytardis/features/ features/
# Based on src/mytardis/build.sh
COPY src/mytardis/requirements.txt src/mytardis/requirements-base.txt src/mytardis/requirements-docs.txt src/mytardis/requirements-test.txt ./
RUN pip install --no-cache-dir -r requirements.txt
# from src/mytardis/package.json
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get update \
  && apt-get -y install \
    nodejs \
  && apt-get clean
RUN npm install 
# UserWarning: The psycopg2 wheel package will be renamed from release 2.8
# <http://initd.org/psycopg/docs/install.html#binary-install-from-pypi>
RUN pip install --no-cache-dir \
  psycopg2-binary

# Publication forms
#RUN pip install --no-cache-dir \
#  -r tardis/apps/publication_forms/requirements.txt

# mytardis-app-mydata
# https://github.com/mytardis/mytardis-app-mydata
COPY src/mydata ./tardis/apps/mydata/
RUN pip install --no-cache-dir \
  -r ./tardis/apps/mydata/requirements.txt

# MyTardis LDAP authentication
RUN pip install --no-cache-dir \
  python-ldap==2.4.45

# Bioformats
# https://github.com/mytardis/mytardisbf
#  openjdk-7-jdk \
#  openjdk-8-jdk \
RUN apt-get update && apt-get -y install \
  openjdk-8-jdk \
  && apt-get clean
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
RUN  pip install -U --no-cache-dir \
    numpy
RUN pip install --no-cache-dir -e git+https://github.com/mytardis/mytardisbf.git@master#egg=mytardisbf
ENV MYTARDIS_BIOFORMATS_ENABLE='False'

# https://pypi.python.org/pypi/django-generate-secret-key/1.0.2
RUN pip install --no-cache-dir \
  django-generate-secret-key==1.0.2

# push_to
#RUN pip install --no-cache-dir \
#  -r tardis/apps/push_to/requirements.txt

# nifcert
COPY ./src/nifcert/ nifcert/
ENV MYTARDIS_NIFCERT_ENABLE='False'

# Bioformats workaround
# Fix schema check migration timing issue; Bioformats fixture loaded in /docker-entrypoint.d/mytardisbf
COPY ./src/mytardisbf_apps.py /usr/src/app/src/mytardisbf/mytardisbf/apps.py
#COPY ./src/forms.py /usr/src/app/tardis/tardis_portal/forms.py
#COPY ./src/widgets.py /usr/src/app/tardis/tardis_portal/widgets.py

COPY docker-entrypoint.d/ /docker-entrypoint.d/
COPY docker-entrypoint_celery.d/ /docker-entrypoint_celery.d/

COPY settings.d/ ./settings.d/
COPY settings_pre.py ./settings_pre.py
