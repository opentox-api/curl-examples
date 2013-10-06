#!/bin/bash
#Your username:
export username=guest
#Your password:
export password=guest
#Acquire a token from the OpenSSO Server:
export token=`curl -X POST -k 'https://opensso.in-silico.ch:443/auth/authenticate?uri=service=openldap' -d username=$username -d password=$password 2> /dev/null`
token=`echo $token | cut -c10-80`;
echo "[TOKEN] $token"
#Invalidate the token
curl -d subjectid=$token http://opensso.in-silico.ch/opensso/identity/logout
