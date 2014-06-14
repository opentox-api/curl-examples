#!/bin/bash

#First the client needs to provide their credentials
#so as to acquire an authentication token from the
#SSO server at opensso.in-silico.ch

msg='[curl-examples/feature]';

echo "$msg authenticating..."

#Your username:
username=guest

#Your password:
password=guest

#Acquire a token from the OpenSSO Server:
token=`curl -X POST -k \
   'https://opensso.in-silico.ch:443/auth/authenticate?uri=service=openldap'\
   -d username=$username \
   -d password=$password 2> /dev/null`
token=`echo $token | cut -c10-80`;
echo "[Token ] $token";


echo "$msg done!";

echo "$msg POSTing the feature...";
feature_uri=`curl -X POST --data-binary @myfeature.rdf\
  -H "subjectid:$token" \
  http://apps.ideaconsult.net:8080/ambit2/feature/ \
  -H Content-type:application/rdf+xml 2> /dev/null`;
echo "$msg done! New feature created: $feature_uri"

echo "$msg logging out";
#Invalidate the token
curl -d subjectid=$token http://opensso.in-silico.ch/opensso/identity/logout
