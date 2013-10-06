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
echo "[Token     ] $token";


#Then the token is passed to the algorithm service
#which in turn will ask the SSO server whether the
#user has access to the requested resource. Upon
#successful authorization, the training procedure will
#start; a Task URI is returned to the client which
#will be used to monitor the progress of the training
#procedure:

#Train a model:
task_uri=`curl -X POST http://opentox.ntua.gr:8080/algorithm/mlr -H subjectid:$token -H Accept:text/uri-list -d dataset_uri=http://apps.ideaconsult.net:8080/ambit2/dataset/R545 -d prediction_feature=http://apps.ideaconsult.net:8080/ambit2/feature/22200 2> /dev/null` 
echo "[Task URI  ] $task_uri"
status=$(curl --write-out %{http_code} --silent --output /dev/null $task_uri)


#Monitoring: While the background job is running, the
#Task interface is used to monitor its progress. 
while [ $status -eq 202 ]
do
  sleep 2
  status=$(curl --write-out %{http_code} --silent --output /dev/null $task_uri)
done

#When the training is complete, a model URI 
#is returned to the client. A default policy applies
#so only the creator has access to this resource.
#If it was created by the user 'guest' all authenticated
#clients have access.
model_uri=`curl -H subjectid:$token -H Accept:text/uri-list $task_uri 2> /dev/null`
echo "[Model URI ] $model_uri"

#Invalidate the token: It is highly recommended
#to invalidate your token at the end of every session (which
#may of course involve multiple requests).
curl -d subjectid=$token http://opensso.in-silico.ch/opensso/identity/logout
