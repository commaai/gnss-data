#!/bin/bash -e

cd "$(dirname "$0")"

# /gnss/data/daily/
lftp -d -u $FTP_CREDS -e 'set ftp:ssl-force true' -e 'mirror --only-missing --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/gnss/data/daily/201[8-9]/ --directory=/gnss/data/daily/20[2-9][0-9]/ --include-glob=[0-9][0-9][0-9]/[0-9][0-9][ng]/brdc[0-9][0-9][0-9]0.[0-9][0-9][ng].Z --include-glob=[0-9][0-9][0-9]/[0-9][0-9][ng]/brdc[0-9][0-9][0-9]0.[0-9][0-9][ng].gz --target-directory=./gnss/data/daily/;exit' gdc.cddis.eosdis.nasa.gov
# /gnss/products/
lftp -d -u $FTP_CREDS -e 'set ftp:ssl-force true' -e 'mirror --only-missing --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/gnss/products/198[2-9]/ --directory=/gnss/products/199[0-9]/ --directory=/gnss/products/[2-9][0-9][0-9][0-9]/ --include-glob=ig[sru][0-9][0-9][0-9][0-9][0-9].sp3.Z --target-directory=./gnss/products/;exit' gdc.cddis.eosdis.nasa.gov
# /gnss/products/ionex/
lftp -d -u $FTP_CREDS -e 'set ftp:ssl-force true' -e 'mirror --only-missing --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/gnss/products/ionex/201[8-9]/ --directory=/gnss/products/ionex/20[2-9][0-9]/ --include-glob=[0-9][0-9][0-9]/codg[0-9][0-9][0-9]0.[0-9][0-9]i.Z -I --include-glob=[0-9][0-9][0-9]/c[12]pg[0-9][0-9][0-9]0.[0-9][0-9]i.Z --target-directory=./gnss/products/ionex/;exit' gdc.cddis.eosdis.nasa.gov
# /gnss/products/bias/
lftp -d -u $FTP_CREDS -e 'set ftp:ssl-force true' -e 'mirror --only-missing --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/gnss/products/bias/201[8-9]/ --directory=/gnss/products/bias/20[2-9][0-9]/ --include-glob=CAS0MGXRAP_[0-9][0-9][0-9][0-9][0-9][0-9][0-9]0000_01D_01D_DCB.BSX.gz --target-directory=./gnss/products/bias/;exit' gdc.cddis.eosdis.nasa.gov
# /glonass/products/
lftp -d -u $FTP_CREDS -e 'set ftp:ssl-force true' -e 'mirror --only-missing --no-empty-dirs --no-perms --no-umask --parallel=10 --directory=/glonass/products/198[2-9]/ --directory=/glonass/products/199[0-9]/ --directory=/glonass/products/[2-9][0-9][0-9][0-9]/ --include-glob=ig[l][0-9][0-9][0-9][0-9][0-9].sp3.Z --target-directory=./glonass/products/;exit' gdc.cddis.eosdis.nasa.gov

