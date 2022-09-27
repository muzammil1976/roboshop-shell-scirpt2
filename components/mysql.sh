source components/common.sh

CHECK_ROOT
PRINT "configure YUM repos"

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
CHECK_STAT $?

PRINT "install MySQL"
yum install mysql-community-server -y &>>${LOG}
systemctl enable mysqld &>>${LOG} && systemctl start mysqld &>>${LOG}
CHECK_STAT $?

MYSQL_DEFAULT_PASSWARD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

PRINT "RESET Root Password"
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_PASSWARD';" >/tmp/mysql | mysql --connect-expire-password -uroot -p"${MYSQL_DEFAULT_PASSWARD}" </tmp/mysql
CHECK_STAT $?

exit
ccho "uninstall plugin validate_passward;" | mysql -uroot -p"${MYSQL_PASSWARD}"

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"

cd /tmp
unzip -O mysql.zip
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql
