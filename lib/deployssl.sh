#!/bin/sh

#$racadm set iDrac.Security.CsrKeySize 4096

$racadm sslkeyupload  -t 1 -f cert/key.pem
$racadm sslcertupload -t 1 -f cert/bundle.pem

