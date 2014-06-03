#!/bin/bash

#First the client needs to provide their credentials
#so as to acquire an authentication token from the
#SSO server at opensso.in-silico.ch

#Your username:
username=guest

#Your password:
password=guest

#Acquire a token from the OpenSSO Server:
token=`curl -X POST -k 'https://opensso.in-silico.ch:443/auth/authenticate?uri=service=openldap' -d username=$username -d password=$password 2> /dev/null`
token=`echo $token | cut -c10-80`;
echo "[Token ] $token";
