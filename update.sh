#!/bin/bash -e

cd "$(dirname "$0")"

HH="[0-2][0-9]"
YY="[0-9][0-9]"
DOY="[0-9][0-9][0-9]"
DOW="[0-9]"
GPS_WEEK="[0-9][0-9][0-9][0-9]"

echo "STARTING: /gnss/data/daily/"
lftp -d -u anonymous,admin@comma.ai -e "set ftp:ssl-force true" -e "mirror --only-missing --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/gnss/data/daily/202[1-9]/ --directory=/gnss/data/daily/20[3-9][0-9]/ --include-glob=${DOY}/${YY}[ng]/brdc${DOY}0.${YY}[ng].Z --include-glob=${DOY}/${YY}[ng]/brdc${DOY}0.${YY}[ng].gz --target-directory=./gnss/data/daily/;exit" gdc.cddis.eosdis.nasa.gov

echo "STARTING: /gnss/products/"
lftp -d -u anonymous,admin@comma.ai -e "set ftp:ssl-force true" -e "mirror --only-missing --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/gnss/products/21[4-9][0-9]/ --directory=/gnss/products/2[2-9][0-9][0-9]/ --directory=/gnss/products/[3-9][0-9][0-9][0-9]/ --include-glob=ig[sr]${GPS_WEEK}${DOW}.sp3.Z --include-glob=igu${GPS_WEEK}${DOW}_${HH}.sp3.Z --target-directory=./gnss/products/;exit" gdc.cddis.eosdis.nasa.gov

echo "STARTING: /gnss/products/ionex/"
lftp -d -u anonymous,admin@comma.ai -e "set ftp:ssl-force true" -e "mirror --only-missing --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/gnss/products/ionex/202[1-9]/ --directory=/gnss/products/ionex/20[3-9][0-9]/ --include-glob=${DOY}/codg${DOY}0.${YY}i.Z -I --include-glob=${DOY}/c[12]pg${DOY}0.${YY}i.Z --target-directory=./gnss/products/ionex/;exit" gdc.cddis.eosdis.nasa.gov

echo "STARTING: /gnss/products/bias/"
lftp -d -u anonymous,admin@comma.ai -e "set ftp:ssl-force true" -e "mirror --only-missing --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/gnss/products/bias/202[1-9]/ --directory=/gnss/products/bias/20[3-9][0-9]/ --include-glob=*_DCB.BSX.gz --target-directory=./gnss/products/bias/;exit" gdc.cddis.eosdis.nasa.gov

echo "STARTING: /glonass/products/"
lftp -d -u anonymous,admin@comma.ai -e "set ftp:ssl-force true" -e "mirror --only-missing --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/glonass/products/21[4-9][0-9]/ --directory=/glonass/products/2[2-9][0-9][0-9]/ --directory=/glonass/products/[3-9][0-9][0-9][0-9]/ --include-glob=ig[l]${GPS_WEEK}${DOW}.sp3.Z --target-directory=./glonass/products/;exit" gdc.cddis.eosdis.nasa.gov
