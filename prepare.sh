#! /bin/bash

ROOT=`pwd`
DRUPAL_DIR=$ROOT/files/drupal
modules=(
  antispam-7.x-1.5.tar.gz \
  boost-7.x-1.0-beta2.tar.gz \
  captcha-7.x-1.0.tar.gz \
  cck-7.x-3.0-alpha3.tar.gz \
  ckeditor-7.x-1.13.tar.gz \
  ctools-7.x-1.3.tar.gz \
  date-7.x-2.6.tar.gz \
  dhtml_menu-7.x-1.0-beta1.tar.gz \
  diff-7.x-3.2.tar.gz \
  drush-6.2.0.tar.gz \
  entity-7.x-1.2.tar.gz \
  fbconnect-7.x-2.0-beta4.tar.gz \
  geofield-7.x-2.1.tar.gz \
  geophp-7.x-1.7.tar.gz \
  google_analytics-7.x-1.4.tar.gz \
  hidden_captcha-7.x-1.0.tar.gz \
  httprl-7.x-1.13.tar.gz \
  i18n-7.x-1.10.tar.gz \
  jquery_update-7.x-2.3.tar.gz \
  leaflet-7.x-1.0.tar.gz \
  libraries-7.x-2.1.tar.gz \
  message-7.x-1.9.tar.gz \
  oauth-7.x-3.1.tar.gz \
  openlayers-7.x-2.0-beta7.tar.gz \
  panels-7.x-3.3.tar.gz \
  pathauto-7.x-1.2.tar.gz \
  profile2-7.x-1.3.tar.gz \
  proj4js-7.x-1.2.tar.gz \
  rate-7.x-1.6.tar.gz \
  recaptcha-7.x-1.10.tar.gz \
  search_api-7.x-1.10.tar.gz \
  site_map-7.x-1.0.tar.gz \
  strongarm-7.x-2.0.tar.gz \
  token-7.x-1.5.tar.gz \
  twitter-7.x-5.8.tar.gz \
  variable-7.x-2.3.tar.gz \
  views-7.x-3.7.tar.gz \
  votingapi-7.x-2.11.tar.gz \
)
themes=(bootstrap-7.x-3.0.tar.gz  touch-7.x-1.7.tar.gz)

mkdir -p ${DRUPAL_DIR}/modules
mkdir -p ${DRUPAL_DIR}/themes
mkdir -p ${DRUPAL_DIR}/libraries

cd ${DRUPAL_DIR}
wget -c -N http://ftp.drupal.org/files/projects/drupal-7.24.tar.gz

cd ${DRUPAL_DIR}/modules
for item in ${modules[*]}
do
    wget -c -N http://ftp.drupal.org/files/projects/$item
done

cd ${DRUPAL_DIR}/themes
for item in ${themes[*]}
do
    wget -c -N http://ftp.drupal.org/files/projects/$item
done
