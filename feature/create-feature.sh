#!/bin/bash

#First the client needs to provide their credentials
#so as to acquire an authentication token from the
#SSO server at opensso.in-silico.ch


echo '[curl-examples/feature] authenticating...'

#Your username:
username=guest

#Your password:
password=guest

#Acquire a token from the OpenSSO Server:
token=`curl -X POST -k 'https://opensso.in-silico.ch:443/auth/authenticate?uri=service=openldap' -d username=$username -d password=$password 2> /dev/null`
token=`echo $token | cut -c10-80`;
echo "[Token ] $token";


echo '[curl-examples/feature] done!';

echo '[curl-examples/feature] POSTing the feature...'
feature_uri=`curl -X POST --data-binary @myfeature.rdf\
  -H "subjectid:$token" \
  http://apps.ideaconsult.net:8080/ambit2/feature/ \
  -H Content-type:application/rdf+xml 2> /dev/null`;
echo '[curk-examples/feature] done! New feature created:'
echo $feature_uri;


echo '[curl-examples/feature] logging out';
#Invalidate the token
curl -d subjectid=$token http://opensso.in-silico.ch/opensso/identity/logout
