source components/common.sh

CHECK_ROOT

PRINT "setting up NodeJS YUM Repo is "
url -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
CHECK_STAT $?

PRINT "Installing NodeJS"
yum install nodejs -y &>>${LOG}
CHECK_STAT $?

PRINT "Creating Application User"
id roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG}
fi
CHECK_STAT $?

PRINT "Downloading Cart Content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>${LOG}
CHECK_STAT $?

cd /home/roboshop

PRINT  "Remove old content"
rm -rf cart &>>${LOG}
CHECK_STAT $?

PRINT  "Exrtact old content"
unzip /tmp/cart.zip &>>${LOG}
CHECK_STAT $?

mv cart-main cart
cd cart

PRINT "install NodeJS Dependencies for Cart Component"
rpm install &>>${LOG}
CHECK_STAT $?

PRINT "Update SystemD Configuration"

sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal1976/' -e 'CATALOGUE_ENDPOINT/catalogue.roboshop.internal1976/' /home/roboshop/cart/systemd.service &>>${LOG}
CHECK_STAT $?

PRINT "Setup SystemD Configuration "
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
CHECK_STAT $?

systemctl daemon-reload
systemctl restart cart
systemctl enable cart