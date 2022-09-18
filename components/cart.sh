source components/common.sh

CHECK_ROOT

PRINT "setting up NodeJS YUM Repo is "
url -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
CHECK_STAT $?

PRINT "Installing NodeJS"
yum install nodejs -y &>>${LOG}
CHECK_STAT $?

echo "Creating Application User"
useradd roboshop &>>${LOG}
CHECK_STAT $?

echo "Downloading Cart Content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>${log}
CHECK_STAT $?

cd /home/roboshop

echo "Remove old content"
rm -rf cart &>>${LOG}
CHECK_STAT $?

echo "Exrtact old content"
unzip /tmp/cart.zip &>>${LOG}
CHECK_STAT $?

mv cart-main cart
cd cart

PRINT "install NodeJS
if [ $? -ne 0 ]; then
  echo FAILED
  exit 2
else
  echo SUCCESS
fi

yum install nodejs -y
useradd roboshop
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
cd /home/roboshop
rm -rf cart
unzip /tmp/cart.zip
mv cart-main cart
cd cart
npm install
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal1976/' -e 'CATALOGUE_ENDPOINT/catalogue.roboshop.internal1976/' /home/roboshop/cart/systemd.service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl restart cart
systemctl enable cart