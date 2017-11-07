#! /bin/bash

function cfg_replace_option {
  grep "$1" "$3" > /dev/null
  if [ $? -eq 0 ]; then
    # replace option
    echo "replacing option  $1=$2  in  $3"
    sed -i "s#^\($1\s*=\s*\).*\$#\1$2#" $3
    if (( $? )); then
      echo "cfg_replace_option failed"
      exit 1
    fi
  else
    # add option if it does not exist
    echo "adding option  $1=$2  in  $3"
    echo "$1=$2" >> $3
  fi
}

LDAP_CONFIG_FILE=${LDAP_CONFIG_FILE=$RED5_HOME/webapps/openmeetings/conf/om_ldap.cfg}

LDAP_CONN_HOST=${LDAP_CONN_HOST:-dc.example.com}
LDAP_CONN_PORT=${LDAP_CONN_PORT:-389}
LDAP_CONN_SECURE=${LDAP_CONN_SECURE:-false}

LDAP_ADMIN_DN=${LDAP_ADMIN_DN:-CN=openmeetings,OU=LDAP bind users,DC=example,DC=com}

LDAP_PASSWD=${LDAP_PASSWD:-Ch4ng3m3}

LDAP_SEARCH_BASE=${LDAP_SEARCH_BASE:-OU=users,DC=example,DC=com}

LDAP_SEARCH_QUERY=${LDAP_SEARCH_QUERY:-(uid=%s)}

LDAP_SEARCH_SCOPE=${LDAP_SEARCH_SCOPE:-ONELEVEL}

LDAP_AUTH_TYPE=${LDAP_AUTH_TYPE:-SIMPLEBIND}

LDAP_USERDN_FORMAT=${LDAP_USERDN_FORMAT:-uid=%s,OU=Company,DC=medint,DC=local}

LDAP_PROVISIONNING=${LDAP_PROVISIONNING:-AUTOCREATE}

LDAP_DEREF_MODE=${LDAP_DEREF_MODE:-always}

LDAP_USE_ADMIN_TO_GET_ATTRS=${LDAP_USE_ADMIN_TO_GET_ATTRS:-true}

LDAP_SYNC_PASSWORD_TO_OM=${LDAP_SYNC_PASSWORD_TO_OM:-true}

LDAP_GROUP_MODE=${LDAP_GROUP_MODE:-NONE}
LDAP_GROUP_QUERY=${LDAP_GROUP_QUERY:-(&(memberUid=%s)(objectClass=posixGroup))}

LDAP_USER_ATTR_LOGIN=${LDAP_USER_ATTR_LOGIN:-uid}
LDAP_USER_ATTR_LASTNAME=${LDAP_USER_ATTR_LASTNAME:-sn}
LDAP_USER_ATTR_FIRSTNAME=${LDAP_USER_ATTR_FIRSTNAME:-givenName}
LDAP_USER_ATTR_MAIL=${LDAP_USER_ATTR_MAIL:-mail}
LDAP_USER_ATTR_STREET=${LDAP_USER_ATTR_STREET:-streetAddress}
LDAP_USER_ATTR_ADDITIONALNAME=${LDAP_USER_ATTR_ADDITIONALNAME:-description}
LDAP_USER_ATTR_FAX=${LDAP_USER_ATTR_FAX:-facsimileTelephoneNumber}
LDAP_USER_ATTR_ZIP=${LDAP_USER_ATTR_ZIP:-postalCode}
LDAP_USER_ATTR_COUNTRY=${LDAP_USER_ATTR_COUNTRY:-co}
LDAP_USER_ATTR_TOWN=${LDAP_USER_ATTR_TOWN:-l}
LDAP_USER_ATTR_PHONE=${LDAP_USER_ATTR_PHONE:-telephoneNumber}
LDAP_GROUP_ATTR=${LDAP_GROUP_ATTR:-MemberOf}

#LDAP_USER_PICTURE_URI=${LDAP_USER_PICTURE_URI}
#LDAP_USER_TIMEZONE=${LDAP_USER_TIMEZONE}

LDAP_USE_LOWER_CASE=${LDAP_USE_LOWER_CASE:-false}

LDAP_IMPORT_QUERY=${LDAP_IMPORT_QUERY:-(objectClass=inetOrgPerson)}

if [ "LDAP_FLAVOR" == 'ad' ]; then
	LDAP_SEARCH_QUERY=(userPrincipalName=%1$s)
	LDAP_USERDN_FORMAT=sAMAccountName=%s
	LDAP_GROUP_QUEY=(objectClass=group)
	LDAP_USER_ATTR_LOGIN=sAMAccountName
	LDAP_IMPORT_QUERY=(&(objectclass=user)(userAccountControl:1.2.840.113556.1.4.803:=512))
	LDAP_CONFIG_FILE=${LDAP_CONFIG_FILE:-$RED5_HOME/webapps/openmeetings/conf/om_ad.cfg}
fi

cfg_replace_option ldap_conn_host $LDAP_CONN_HOST $LDAP_CONFIG_FILE
cfg_replace_option ldap_conn_port $LDAP_CONN_PORT $LDAP_CONFIG_FILE
cfg_replace_option ldap_conn_secure $LDAP_CONN_SECURE $LDAP_CONFIG_FILE
cfg_replace_option ldap_admin_dn $LDAP_ADMIN_DN $LDAP_CONFIG_FILE
cfg_replace_option ldap_passwd $LDAP_PASSWD $LDAP_CONFIG_FILE
cfg_replace_option ldap_search_base $LDAP_SEARCH_BASE $LDAP_CONFIG_FILE
cfg_replace_option ldap_search_query $LDAP_SEARCH_QUERY $LDAP_CONFIG_FILE
cfg_replace_option ldap_search_scope $LDAP_SEARCH_SCOPE $LDAP_CONFIG_FILE
cfg_replace_option ldap_auth_type $LDAP_AUTH_TYPE $LDAP_CONFIG_FILE
cfg_replace_option ldap_userdn_format $LDAP_USERDN_FORMAT $LDAP_CONFIG_FILE
cfg_replace_option ldap_provisionning $LDAP_PROVISIONNING $LDAP_CONFIG_FILE
cfg_replace_option ldap_deref_mode $LDAP_DEREF_MODE $LDAP_CONFIG_FILE
cfg_replace_option ldap_use_admin_to_get_attrs $LDAP_USE_ADMIN_TO_GET_ATTRS $LDAP_CONFIG_FILE
cfg_replace_option ldap_sync_password_to_om $LDAP_SYNC_PASSWORD_TO_OM $LDAP_CONFIG_FILE
cfg_replace_option ldap_group_mode $LDAP_GROUP_MODE $LDAP_CONFIG_FILE
cfg_replace_option ldap_group_query $LDAP_GROUP_QUERY $LDAP_CONFIG_FILE
cfg_replace_option ldap_user_attr_login $LDAP_USER_ATTR_LOGIN $LDAP_CONFIG_FILE
cfg_replace_option ldap_user_attr_lastname $LDAP_USER_ATTR_LASTNAME $LDAP_CONFIG_FILE
cfg_replace_option ldap_user_attr_firstname $LDAP_USER_ATTR_FIRSTNAME $LDAP_CONFIG_FILE
cfg_replace_option ldap_user_attr_mail $LDAP_USER_ATTR_MAIL $LDAP_CONFIG_FILE
cfg_replace_option ldap_user_attr_street $LDAP_USER_ATTR_STREET $LDAP_CONFIG_FILE
cfg_replace_option ldap_user_attr_additionalname $LDAP_USER_ATTR_ADDITIONALNAME $LDAP_CONFIG_FILE
cfg_replace_option ldap_user_attr_fax $LDAP_USER_ATTR_FAX $LDAP_CONFIG_FILE
cfg_replace_option ldap_user_attr_zip $LDAP_USER_ATTR_ZIP $LDAP_CONFIG_FILE
cfg_replace_option ldap_user_attr_country $LDAP_USER_ATTR_COUNTRY $LDAP_CONFIG_FILE
cfg_replace_option ldap_user_attr_town $LDAP_USER_ATTR_TOWN $LDAP_CONFIG_FILE
cfg_replace_option ldap_user_attr_phone $LDAP_USER_ATTR_PHONE $LDAP_CONFIG_FILE
cfg_replace_option ldap_group_attr $LDAP_GROUP_ATTR $LDAP_CONFIG_FILE
cfg_replace_option ldap_use_lower_case $LDAP_USE_LOWER_CASE $LDAP_CONFIG_FILE
cfg_replace_option ldap_import_query $LDAP_IMPORT_QUERY $LDAP_CONFIG_FILE


# if we're linked to MySQL and thus have credentials already, let's use them
if [[ -v MYSQL_ENV_GOSU_VERSION ]]; then
    : ${DB_TYPE='mysql'}
    : ${DB_USERNAME:=${MYSQL_ENV_MYSQL_USER:-root}}
    if [ "$DB_USERNAME" = 'root' ]; then
        : ${DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
    fi
    : ${DB_PASSWORD:=$MYSQL_ENV_MYSQL_PASSWORD}
    : ${DB_NAME:=${MYSQL_ENV_MYSQL_DATABASE:-squashtm}}
    : ${DB_URL="jdbc:mysql://mysql:3306/$DB_NAME"}

    cp $RED5_HOME/webapps/openmeetings/WEB-INF/classes/META-INF/mysql_persistence.xml $RED5_HOME/webapps/openmeetings/WEB-INF/classes/META-INF/mysql_persistence.xml.original

    xmlstarlet ed \
        -P -S -L \
        -N x="http://java.sun.com/xml/ns/persistence" \
        -u '//x:persistence//x:persistence-unit[@name="openmeetings"]//x:properties//x:property[@name="openjpa.ConnectionProperties"]/@value' \
        -v "DriverClassName=com.mysql.jdbc.Driver,Url=$DB_URL?autoReconnect=true&amp;useUnicode=true&amp;createDatabaseIfNotExist=true&amp;characterEncoding=utf-8&amp;connectionCollation=utf8_general_ci&amp;cachePrepStmts=true&amp;cacheCallableStatements=true&amp;cacheServerConfiguration=true&amp;useLocalSessionState=true&amp;elideSetAutoCommits=true&amp;alwaysSendSetIsolation=false&amp;enableQueryTimeouts=false&amp;prepStmtCacheSize=3000&amp;prepStmtCacheSqlLimit=1000&amp;useSSL=false,MaxActive=100,MaxWait=10000,TestOnBorrow=true,poolPreparedStatements=true,Username=$DB_USERNAME,Password=$DB_PASSWORD" \
        $RED5_HOME/webapps/openmeetings/WEB-INF/classes/META-INF/mysql_persistence.xml

    if [ -z "$DB_PASSWORD" ]; then
        echo >&2 'error: missing required DB_PASSWORD environment variable'
        echo >&2 '  Did you forget to -e DB_PASSWORD=... ?'
        echo >&2
        echo >&2 '  (Also of interest might be DB_USERNAME and DB_NAME.)'
        exit 1
    fi

    cp $RED5_HOME/webapps/openmeetings/WEB-INF/classes/META-INF/mysql_persistence.xml $RED5_HOME/webapps/openmeetings/WEB-INF/classes/META-INF/persistence.xml
fi

# if we're linked to PostgreSQL and thus have credentials already, let's use them
if [[ -v POSTGRES_ENV_GOSU_VERSION ]]; then
    : ${DB_TYPE='postgresql'}
    : ${DB_USERNAME:=${POSTGRES_ENV_POSTGRES_USER:-root}}
    if [ "$DB_USERNAME" = 'postgres' ]; then
        : ${DB_PASSWORD:='postgres' }
    fi
    : ${DB_PASSWORD:=$POSTGRES_ENV_POSTGRES_PASSWORD}
    : ${DB_NAME:=${POSTGRES_ENV_POSTGRES_DB:-squashtm}}
    : ${DB_URL="jdbc:postgresql://postgres:5432/$DB_NAME"}

    cp $RED5_HOME/webapps/openmeetings/WEB-INF/classes/META-INF/postgresql_persistence.xml $RED5_HOME/webapps/openmeetings/WEB-INF/classes/META-INF/postgresql_persistence.xml.original
    
    xmlstarlet ed \
        -P -S -L \
        -N x="http://java.sun.com/xml/ns/persistence" \
        -u '//x:persistence//x:persistence-unit[@name="openmeetings"]//x:properties//x:property[@name="openjpa.ConnectionProperties"]/@value' \
        -v "DriverClassName=org.postgresql.Driver,Url=$DB_URL,MaxActive=100,MaxWait=10000,TestOnBorrow=true,poolPreparedStatements=true,Username=$DB_USERNAME,Password=$DB_PASSWORD" \
        $RED5_HOME/webapps/openmeetings/WEB-INF/classes/META-INF/postgresql_persistence.xml

    if [ -z "$DB_PASSWORD" ]; then
        echo >&2 'error: missing required DB_PASSWORD environment variable'
        echo >&2 '  Did you forget to -e DB_PASSWORD=... ?'
        echo >&2
        echo >&2 '  (Also of interest might be DB_USERNAME and DB_NAME.)'
        exit 1
    fi

    cp $RED5_HOME/webapps/openmeetings/WEB-INF/classes/META-INF/postgresql_persistence.xml $RED5_HOME/webapps/openmeetings/WEB-INF/classes/META-INF/persistence.xml
fi

exec "$@"

