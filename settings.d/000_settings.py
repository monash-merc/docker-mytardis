INSTALLED_APPS += (
    'bootstrapform',
    'django.contrib.sites',
    'django.contrib.admindocs',
    'django.contrib.humanize',
    'django_extensions',
    'kombu.transport.django',
    'jstemplate',
    'registration',
    'tastypie',
    'tastypie_swagger',
    'tardis.analytics',
    'tardis.apps.oaipmh',
    #'tardis.apps.publication_forms',
    'tardis.search',
    'tardis.tardis_portal',
    'tardis.tardis_portal.templatetags',
    'tardis.apps.sftp',
)

MIDDLEWARE += (
    'tardis.tardis_portal.logging_middleware.LoggingMiddleware',
    'tardis.tardis_portal.auth.token_auth.TokenAuthMiddleware',
)
FILTER_MIDDLEWARE = ()
POST_SAVE_FILTERS = []

ADMINS = []
DEFAULT_STORAGE_BASE_DIR = os.path.join(BASE_DIR,'var','store')
FILE_STORE_PATH = DEFAULT_STORAGE_BASE_DIR
MANAGERS = ADMINS
MEDIA_ROOT = DEFAULT_STORAGE_BASE_DIR
MEDIA_URL = None
METADATA_STORE_PATH = DEFAULT_STORAGE_BASE_DIR
STAGING_PATH = os.path.join(BASE_DIR,'var','staging')
TARDIS_APP_ROOT = 'tardis.apps'

DEFAULT_PATH_MAPPER = 'deep-storage'

TIME_ZONE = "Australia/Melbourne"
