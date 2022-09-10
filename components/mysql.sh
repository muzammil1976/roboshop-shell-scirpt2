curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld

MYSQL_DEFAULT_PASSWARD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_PASSWARD';" >/tmp/mysql | mysql --connect-expire-password -uroot -p"${MYSQL_DEFAULT_PASSWARD}" </tmp/mysql

ccho "uninstall plugin validate_passward;" | mysql -uroot -p"${MYSQL_PASSWARD}"

1. Now a default root password will be generated and given in the log file.

# mysql_secure_installation
```

1. You can check the new password working or not using the following command in MySQL

First lets connect to MySQL

```bash
# mysql -uroot -pRoboShop@1
```

Once after login to MySQL prompt then run this SQL Command.

```sql
> uninstall plugin validate_password;
```

## **Setup Needed for Application.**

As per the architecture diagram, MySQL is needed by

- Shipping Service

So we need to load that schema into the database, So those applications will detect them and run accordingly.

To download schema, Use the following command

```bash
# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
```

Load the schema for Services.