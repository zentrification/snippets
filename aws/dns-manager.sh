#!/bin/bash

DOMAIN=$1
IP=""

usage() {
  printf "Usage $0 domain.tld [options]
     -c               creates zone
                              A records       domain.tld   $IP
                                              *.domain.tld $IP
     -d               deletes zone
     -g               configures google apps
                              MX records      alt1.aspmx.l.google.com ...
                              CNAME records   docs, calendar, mail, sites
     -m ip_address    configures old mailservers
                              A record        ip_address
                              CNAME           mail/smtp/imap/pop/pop3 mail.domain.tld
                              MX record       mail.domain.tld
"
}
testdomain() {
  TEST=`route53 -l $DOMAIN`
  if [ -n $TEST ]
  then
    echo "ERROR"
    echo "  Domain: '$DOMAIN' does not exist, please run ''$0 $DOMAIN -c'"
    exit
  fi
}
google() {
  echo "configuring google MX and CNAME records for $DOMAIN"

  for CNAME in calendar docs mail sites
  do
    route53 --zone $DOMAIN. -c --name $CNAME.$DOMAIN. --type cname --ttl 3600 --values ghs.google.com.
  done

  route53 --zone $DOMAIN. -c --name $DOMAIN. --type MX --ttl 3600 \
    --values "1 aspmx.l.google.com.","5 alt1.aspmx.l.google.com.","5 alt2.aspmx.l.google.com.","10 aspmx2.googlemail.com.","10 aspmx3.googlemail.com."

  route53 -l $1 | grep -i google
}
printdns() {
  echo "DNS records for $DOMAIN"
  route53 -l $DOMAIN
}

if [ "$#" -eq 0 ]
then   # Script needs at least one command-line argument.
  usage
  exit $E_OPTERR
fi

set -- `getopt "cdgm:" "$@"`
# Sets positional parameters to command-line arguments.
# What happens if you use "$*" instead of "$@"?

while [ ! -z "$1" ]
do
  case "$1" in
    -c) 
      echo "Creating domain $DOMAIN"
      route53 -n $DOMAIN.
      route53 --zone $DOMAIN. -c --name $DOMAIN. --type A --ttl 3600 --values $IP
      route53 --zone $DOMAIN. -c --name *.$DOMAIN. --type CNAME --ttl 3600 --values $DOMAIN.
      printdns
      ;;
    -g)
      testdomain
      google
      ;;
    -m)
      testdomain
      if [ -z $2 ]
      then
        echo "ERROR"
        echo " Invalid IP address: $2"
        exit
      fi

      route53 --zone $DOMAIN. -c --name mail.$DOMAIN. --type a --ttl 3600 --values $2
      for CNAME in imap pop pop3 smtp
      do
        route53 --zone $DOMAIN. -c --name $CNAME.$DOMAIN. --type cname --ttl 3600 --values mail.$DOMAIN.
      done

      route53 --zone $DOMAIN. -c --name $DOMAIN. --type MX --ttl 3600 --values "10 mail.$DOMAIN."

      route53 -l $1 | grep -i google
      ;;
    -d)
      testdomain
      route53 --zone $DOMAIN. -r
      route53 --zone $DOMAIN. -d
      ;;
  esac

  shift
done

exit 0
