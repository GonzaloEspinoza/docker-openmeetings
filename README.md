[![](https://images.microbadger.com/badges/image/fjudith/openmeetings.svg)](https://microbadger.com/images/fjudith/openmeetings "Get your own image badge on microbadger.com")

# Introduction

OpenMeetings is software used for presenting, online training, web conferencing, collaborative whiteboard drawing and document editing, and user desktop sharing.

# Description

The Dockerfile builds from "openjdk" see https://hub.docker.com/_/openjdk/

# Roadmap

* [X] Swtools and Pdf2Swf support
* [X] ffMpeg support
* [X] JodConverter support
* [X] LibreOffice support 
* [x] External linked database autoconf (PosgreSQL, MySQL)
* [ ] LDAP autoconf
* [ ] Persistent data volumes
 

# Quick Start

You will need to open 2 ports:

- 1935 RTMP (Flash Stream and Remoting/RPC)
- 5080 HTTP (For example for file upload and download)
- 8081 for WebSockets

```bash
docker run -it --rm --name openmeetings -p 1935:1935 -p 5080:5080 -p 8081:8081 fjudith/openmeetings
```

Then open http://ipaddress:5080/openmeetings and proceed to the installation

# Configuration
## Environment variables

* **LDAP_CONN_HOST**: Specifies the Ldap server hostname or ip address; default=`dc.example.com`
* **LDAP_CONN_PORT**: Specifies the Ldap server listen port; default=`389`
* **LDAP_CONN_SECURE**: Specifies wether SSL encryption enabled for LDAP protocol (default port **636**); default=`false`
* **LDAP_ADMIN_DN**: Specifies the LDAP user allowed to perform user authentication against the LDAP server; default=`CN=openmeetings,OU=LDAP bind users,DC=example,DC=com`
* **LDAP_PASSWD**: Specifies the LDAP user password; default=`Ch4ng3m3`
* **LDAP_SEARCH_BASE**: Specifies the LDAP directory containing OpenMeetings granted users; default=`OU=users,DC=example,DC=com`
* **LDAP_SEARCH_QUERY**: Specifies the LDAP object to identify the user name; default=`(uid=%s)`
* **LDAP_SEARCH_SCOPE**: Specifies the scope of the LDAP search; default=`ONELEVEL`
* **LDAP_AUTH_TYPE**: Specifies the type of LDAP authentication to be performed; default=`SIMPLEBIND`
* **LDAP_USERDN_FORMAT**: Specifies the LDAP user object pattern; default=`uid=%s,OU=Company,DC=medint,DC=local`
* **LDAP_PROVISIONNING**: Specifies wether LDAP authenticated users are automatically created in OpenMeetings; default=`AUTOCREATE`
* **LDAP_DEREF_MODE**: ; default=`always`
* **LDAP_USE_ADMIN_TO_GET_ATTRS**: ; default=`true`
* **LDAP_SYNC_PASSWORD_TO_OM**: ; default=`true`
* **LDAP_GROUP_MODE**: ; default=`NONE`
* **LDAP_GROUP_QUERY**: ; default=`(&(memberUid=%s)(objectClass=posixGroup))`

* **LDAP_USER_ATTR_LOGIN**: Specifies the LDAP attribute containing the login name; default=`uid`
* **LDAP_USER_ATTR_LASTNAME**: Specifies the attribute containing the user Lastname; default=`sn`
* **LDAP_USER_ATTR_FIRSTNAME**: Specifies the attribute containing the user FirstName; default=`givenName`
* **LDAP_USER_ATTR_MAIL**: Specifies the attribute containing the user E-Mail address; default=`mail`
* **LDAP_USER_ATTR_STREET**: Specifies the attribute containing the user street address; default=`streetAddress`
* **LDAP_USER_ATTR_ADDITIONALNAME**: Specifies the attribute containing the user additional name; default=`description`
* **LDAP_USER_ATTR_FAX**: Specifies the attribute containing the user Fax number; default=`facsimileTelephoneNumber`
* **LDAP_USER_ATTR_ZIP**: Specifies the attribute containing the user Zip code; default=`postalCode`
* **LDAP_USER_ATTR_COUNTRY**: Specifies the attribute contaning the user country; default=`co`
* **LDAP_USER_ATTR_TOWN**: Specifies the attribute containing the user town; default=`l`
* **LDAP_USER_ATTR_PHONE**: Specifies the attribute containing the user telephone number; default=`telephoneNumber`

* **LDAP_GROUP_ATTR**: Specifies the attribute containing the group members; default=`MemberOf`

* **LDAP_USE_LOWER_CASE**: Specifies wether lower case should be enforce during the authentication process; default=`false`
* **LDAP_IMPORT_QUERY**: Specifies the key of objects to import; default=`inetOrgPerson`

#### Active Directory Specifics

* **LDAP_SEARCH_QUERY**: Specifies the LDAP attribute containing the login name; default=`(userPrincipalName=%1$s)`
* **LDAP_USERDN_FORMAT**: Specifies the LDAP user object pattern; default=`sAMAccountName=%s`
* **LDAP_GROUP_QUERY**: ; default=`(objectClass=group)`
* **LDAP_USER_ATTR_LOGIN**: Specifies the LDAP attribute containing the login name; default=`sAMAccountName`
* **LDAP_IMPORT_QUERY**: Specifies the key of objects to import; default=`(&(objectclass=user)(userAccountControl:1.2.840.113556.1.4.803:=512))`

## Deployment using PostgreSQL
Database is created by the database container and automatically populated by the application container on first run.

```bash
docker run -it -d --name openmeetings-pg \
--restart=always \
-e POSTGRES_USER=openmeetings \
-e POSTGRES_PASSWORD=Ch4ng3M3 \
-e POSTGRES_DB=openmeetings \
-v openmeetings-db:/var/lib/postgresql \
postgres

sleep 10

docker run -it -d --name=openmeetings \
--link openmeetings-pg:postgres \
--restart=always \
-p 1935:1935 \
-p 5080:5080 \
-p 8081:8081 \
fjudith/openmeetings
```

## Deployment using MySQL
Database is created by the database container and automatically populated by the application container on first run.

```bash
docker run -it -d --name openmeetings-md \
-e MYSQL_ROOT_PASSWORD=Ch4ng3M3 \
-e MYSQL_USER=openmeetings \
-e MYSQL_PASSWORD=Ch4ng3M3 \
-e MYSQL_DATABASE=openmeetings \
-v squash-tm-db:/var/lib/mysql/data \
mariadb --character-set-server=utf8_bin --collation-server=utf8_bin

sleep 10

docker run -it -d --name=openmeetings \
--link openmeetings-md:mysql \
--restart=always \
-p 1935:1935 \
-p 5080:5080 \
-p 8081:8081 \
fjudith/openmeetings
```

## Initial setup

Wait 3-5 minutes for Apache OpenMeetings to initialize. then login to http://ipaddress:5080.
Then follow the installation wizard.

![Welcome](https://cdn.rawgit.com/fjudith/docker-openmeetings/master/img/1_Welcome.png)
![Database Configuration](https://cdn.rawgit.com/fjudith/docker-openmeetings/master/img/2_Database_Configuration.png)
![Initial User](https://cdn.rawgit.com/fjudith/docker-openmeetings/master/img/3_Initial_User.png)
![Email Configuration](https://cdn.rawgit.com/fjudith/docker-openmeetings/master/img/4_Email_Configuration.png)
![Third Party Path](https://cdn.rawgit.com/fjudith/docker-openmeetings/master/img/5_Third_Party_Path.png)
![SIP Configuration](https://cdn.rawgit.com/fjudith/docker-openmeetings/master/img/6_SIP_Configuration.png)
![Finish](https://cdn.rawgit.com/fjudith/docker-openmeetings/master/img/7_Finish.png)

## Flash and Java

Unfortunately, OpenMeetings needs Flash to share webcam and Java web plugin to share desktop (only for the sender). On linux, you may installe `icedtea-web` package and use Firefox to be able to send desktop.


## Reference

* https://cwiki.apache.org/confluence/display/OPENMEETINGS/Tutorials+for+installing+OpenMeetings+and+Tools