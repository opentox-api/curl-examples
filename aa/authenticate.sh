#Your username:
export username=guest
#Your password:
export password=guest
#Retrieve the token:
export token=`curl -X POST -k \
  'https://opensso.in-silico.ch:443/auth/authenticate?uri=service=openldap' \
  -d username=$username -d password=$password`
token=`echo $token | cut -c10-80`;
