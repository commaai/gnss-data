#!/bin/bash -e

cd "$(dirname "$0")"

HH="[0-2][0-9]"
YY="[0-9][0-9]"
YYYY="[0-9][0-9][0-9][0-9]"
DOY="[0-9][0-9][0-9]"
DOW="[0-9]"
GPS_WEEK="[0-9][0-9][0-9][0-9]"

CURR_YEAR=$(date -u +%Y)
PREV_YEAR=$(( ${CURR_YEAR} - 1 ))
CURR_GPS_WEEK=$(( ( $(date -u +%s) - $(date -u -d'1980-01-06 00:00:00' +%s) ) / 60 / 60 / 24 / 7 ))
PREV_GPS_WEEK=$(( ${CURR_GPS_WEEK} - 1 ))

echo "STARTING: /gnss/data/daily/"
lftp -d -u anonymous,admin@comma.ai -e "set ftp:ssl-force true" -e "mirror --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/gnss/data/daily/${CURR_YEAR}/ --directory=/gnss/data/daily/${PREV_YEAR}/ --include-glob=${DOY}/${YY}[ng]/brdc${DOY}0.${YY}[ng].Z --include-glob=${DOY}/${YY}[ng]/brdc${DOY}0.${YY}[ng].gz --target-directory=./gnss/data/daily/;exit" gdc.cddis.eosdis.nasa.gov

echo "STARTING: /gnss/products/"
lftp -d -u anonymous,admin@comma.ai -e "set ftp:ssl-force true" -e "mirror --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/gnss/products/${CURR_GPS_WEEK}/ --directory=/gnss/products/${PREV_GPS_WEEK}/ --include-glob=ig[sr]${GPS_WEEK}${DOW}.sp3.Z --include-glob=igu${GPS_WEEK}${DOW}_${HH}.sp3.Z --target-directory=./gnss/products/;exit" gdc.cddis.eosdis.nasa.gov

echo "STARTING: /gnss/products/ionex/"
lftp -d -u anonymous,admin@comma.ai -e "set ftp:ssl-force true" -e "mirror --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/gnss/products/ionex/${CURR_YEAR}/ --directory=/gnss/products/ionex/${PREV_YEAR}/ --include-glob=${DOY}/COD0OPSFIN_${YYYY}${DOY}0000_01D_01H_GIM.INX.gz --include-glob=${DOY}/COD0OPSRAP_${YYYY}${DOY}0000_01D_01H_GIM.INX.gz --target-directory=./gnss/products/ionex/;exit" gdc.cddis.eosdis.nasa.gov

echo "STARTING: /gnss/products/bias/"
lftp -d -u anonymous,admin@comma.ai -e "set ftp:ssl-force true" -e "mirror --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/gnss/products/bias/${CURR_YEAR}/ --directory=/gnss/products/bias/${PREV_YEAR}/ --include-glob=*_DCB.BSX.gz --target-directory=./gnss/products/bias/;exit" gdc.cddis.eosdis.nasa.gov

echo "STARTING: /glonass/products/"
lftp -d -u anonymous,admin@comma.ai -e "set ftp:ssl-force true" -e "mirror --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/glonass/products/${CURR_GPS_WEEK}/ --directory=/glonass/products/${PREV_GPS_WEEK}/ --include-glob=ig[l]${GPS_WEEK}${DOW}.sp3.Z --target-directory=./glonass/products/;exit" gdc.cddis.eosdis.nasa.gov
