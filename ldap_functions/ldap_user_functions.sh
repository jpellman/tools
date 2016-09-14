#!/bin/bash

LDAPDOMAIN="zombo.com"
LDAP_DCS="dc=zombo,dc=com"

function luseradd ()
{
    echo "Enter the full name for the user you wish to add."
    read FULLNAME
    echo "Enter the user name for the user you wish to add."
    read USERNAME
    nextUid=$(( $(ldapsearch -x -H ldap://${LDAPDOMAIN} -S uidNumber | grep uidNumber | awk '{print $2}' | tail -1) + 1 ))
    cat << EOF >> /tmp/newuser.ldif
dn: uid=${USERNAME},ou=People,${LDAP_DCS}
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: ${FULLNAME}
uid: ${USERNAME}
loginShell: /bin/bash
uidNumber: ${nextUid}
gidNumber: 5000
homeDirectory: /home/${USERNAME}
gecos: ${FULLNAME},,,
shadowLastChange: $(($(date --utc --date "$1" +%s)/86400))
shadowMax: 99999
shadowWarning: 7
EOF
    ldapadd -x -H ldap://${LDAPDOMAIN} -W -D "cn=admin,${LDAP_DCS}" -c -f /tmp/newuser.ldif
    rm /tmp/newuser.ldif
    echo "Please choose a password for ${USERNAME}"
    ldappasswd -x -H ldap://${LDAPDOMAIN} -D "cn=admin,${LDAP_DCS}" -S -W -S "uid=${USERNAME},ou=People,${LDAP_DCS}"
}

function luserdel ()
{
    echo "Enter the user name for the user you wish to delete."
    read USERNAME
    ldapdelete -D "cn=admin,${LDAP_DCS}" -W -H ldap://rocky.rfmh.org "uid=${USERNAME},ou=People,${LDAP_DCS}"
}

function lpasswd ()
{
    ldappasswd -H ldap://${LDAPDOMAIN} -x -D "uid=$(whoami),ou=People,${LDAP_DCS}" -W -A -S
}
