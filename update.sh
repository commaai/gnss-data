#!/bin/bash -ex

cd "$(dirname "$0")"

function sync_dir
{
  if [ -z $1 ]; then
    echo "ERROR: target directory value is not set"
    exit 1
  fi
  TARGET_DIR="$1"

  if [ -z $2 ]; then
    echo "ERROR: source directory array is not set"
    exit 1
  fi
  SOURCE_DIRS=($2) # convert space separated string to array

  if [ -z $3 ]; then
    echo "ERROR: include glob array is not set"
    exit 1
  fi
  INCLUDE_GLOBS=($3) # convert space separated string to array

  SERVER_HOSTNAME="gdc.cddis.eosdis.nasa.gov"
  LFTP_MIRROR_OPTS="--no-empty-dirs --no-perms --no-umask --ignore-time --parallel=10"
  lftp -d -u anonymous,admin@comma.ai -e "set ftp:ssl-force true" -e "mirror ${LFTP_MIRROR_OPTS} $(echo ${SOURCE_DIRS[@]/#/--directory=}) $(echo ${INCLUDE_GLOBS[@]/#/--include-glob=}) --target-directory=${TARGET_DIR};exit" ${SERVER_HOSTNAME}
}

HH="[0-2][0-9]"
YY="[0-9][0-9]"
YYYY="[0-9][0-9][0-9][0-9]"
DOY="[0-9][0-9][0-9]"
DOW="[0-9]"
V="[0-9]"
GPS_WEEK="[0-9][0-9][0-9][0-9]"

END_YEAR=$(date -u +%Y)
START_YEAR=$(( ${END_YEAR} - 1 ))
for CURR_YEAR in $(seq ${START_YEAR} ${END_YEAR}); do
  echo "STARTING YEAR: ${CURR_YEAR}"
  #        target dir               source dirs (space separated array)   include globs (space separated array)
  sync_dir "./gnss/data/daily/"     "/gnss/data/daily/${CURR_YEAR}/"      "${DOY}/${YY}[ng]/brdc${DOY}0.${YY}[ng].Z ${DOY}/${YY}[ng]/brdc${DOY}0.${YY}[ng].gz"
  sync_dir "./gnss/products/ionex/" "/gnss/products/ionex/${CURR_YEAR}/"  "${DOY}/COD0OPSFIN_${YYYY}${DOY}0000_01D_01H_GIM.INX.gz ${DOY}/COD0OPSRAP_${YYYY}${DOY}0000_01D_01H_GIM.INX.gz ${DOY}/c2pg${DOY}0.${YY}i.Z"
  sync_dir "./gnss/products/bias/"  "/gnss/products/bias/${CURR_YEAR}/"   "*_DCB.BSX.gz *_DCB.BIA.gz"
done

END_GPS_WEEK=$(( ( $(date -u +%s) - $(date -u -d'1980-01-06 00:00:00' +%s) ) / 60 / 60 / 24 / 7 ))
START_GPS_WEEK=$(( ${END_GPS_WEEK} - 52 ))
for CURR_GPS_WEEK in $(seq ${START_GPS_WEEK} ${END_GPS_WEEK}); do
  echo "STARTING GPS WEEK FOR FINAL ORBITS: ${CURR_GPS_WEEK}"
  sync_dir "./gnss/products/"     "/gnss/products/${CURR_GPS_WEEK}/"    "COD${V}MGXFIN_${YYYY}${DOY}0000_01D_05M_ORB.SP3.gz COD${V}OPSFIN_${YYYY}${DOY}0000_01D_05M_ORB.SP3.gz"
done

START_GPS_WEEK=$(( ${END_GPS_WEEK} - 1 ))
for CURR_GPS_WEEK in $(seq ${START_GPS_WEEK} ${END_GPS_WEEK}); do
  echo "STARTING GPS WEEK FOR RAPID ORBITS: ${CURR_GPS_WEEK}"
  sync_dir "./gnss/products/"     "/gnss/products/${CURR_GPS_WEEK}/"    "COD${V}OPSRAP_${YYYY}${DOY}0000_01D_05M_ORB.SP3.gz COD${V}OPSULT_${YYYY}${DOY}${HH}00_02D_05M_ORB.SP3.gz"
done
