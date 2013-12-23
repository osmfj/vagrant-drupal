class osm_drupal_modules {
  import 'osm_drupal'
  osm_drupal::drush_add{"drush-6.2.0": }

# basic modules
  osm_drupal::module_add{"libraries": }
  osm_drupal::module_add{"boost": }
  osm_drupal::module_add{"cck": }
  osm_drupal::module_add{"ctools": }
  osm_drupal::module_add{"views": }
  osm_drupal::module_add{"date": }
  osm_drupal::module_add{"entity": }
  osm_drupal::module_add{"i18n": }
  osm_drupal::module_add{"jquery_update": }
  osm_drupal::module_add{"token": }
  osm_drupal::module_add{"variable": }

# administration/antispam
  osm_drupal::module_add{"admin_menu": }
  osm_drupal::module_add{"antispam": }
  osm_drupal::module_add{"captcha": }
  osm_drupal::module_add{"hidden_captcha": }
  osm_drupal::module_add{"recaptcha": }
  osm_drupal::module_add{"google_analytics": }
  osm_drupal::module_add{"pathauto": }

# UI improvement
  osm_drupal::module_add{"ckeditor": }
  osm_drupal::module_add{"dhtml_menu": }
  osm_drupal::module_add{"diff": }
  osm_drupal::module_add{"message": }

# Q&A forum
  osm_drupal::module_add{"rate": }
  osm_drupal::module_add{"votingapi": }

# GEO
  osm_drupal::module_add{"geofield": }
  osm_drupal::module_add{"geophp": }
  osm_drupal::module_add{"leaflet": }
  osm_drupal::module_add{"openlayers": }
  osm_drupal::module_add{"proj4js": }
  osm_drupal::module_add{"panels": }

# SignOn
  osm_drupal::module_add{"fbconnect": }
  osm_drupal::module_add{"oauth": }
  osm_drupal::module_add{"httprl": }
  osm_drupal::module_add{"profile2": }
  osm_drupal::module_add{"twitter": }


# Search development
  osm_drupal::module_add{"search_api": }
  osm_drupal::module_add{"site_map": }

# library
  osm_drupal::library_add{"leaflet-0.7.1":}
  osm_drupal::library_add{"facebook-php-sdk-3.2.3":}

# themes
  osm_drupal::theme_add{"touch":}
  osm_drupal::theme_add{"bootstrap":}
}
