#!/bin/bash
signingKey="/data/matrix.signed.key"
if [ ! -f "$signingKey" ] ; then 
    generate_signing_key  -o "$signingKey"
fi
/usr/bin/supervisord
