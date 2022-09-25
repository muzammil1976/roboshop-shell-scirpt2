CHECK_ROOT() {
  USER_ID=$(id -u)
  if [ $USER_ID -ne 0 ]; then
      echo i have sone with autism and he is very aggrassive
      echo you can run this script as root user or with sudo
      exit 1
  fi
}
CHECK_STAT() {
echo "--------------------">>${LOG}
if [ $1 -ne 0 ]; then
  echo -e "\e[31mFAILED\e[0m"
  exit 2
else
  echo -e "32mSUCCESS\e[0m"
fi
}

LOG=/tmp/roboshop.log
rm -f $LOG

PRINT() {
  echo "--------$1 -------" >>${LOG}
  echo "$1"
}
APP_COMMON_SETUP() {

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

}
SystemD () {

   PRINT "Update SystemD Configuration"

    sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal1976/' -e 'CATALOGUE_ENDPOINT/catalogue.roboshop.internal1976/' /home/roboshop/cart/systemd.service &>>${LOG}
    CHECK_STAT $?

    PRINT "Setup SystemD Configuration "
    mv /home/roboshop/cart/systemd.service /etc/systemd/system/${COMPONENT}.service &>>{log} && systemctl daemon-reload
    CHECK_STAT $?



    PRINT "Start ${COMPONENT} service"
    systemctl enable ${COMPONENT} &>>${LOG} && systemctl restart ${COMPONENT} &>>${LOG}
    CHECK_STAT $?
}
NODEJS() {

  CHECK_ROOT

  PRINT "setting up NodeJS YUM Repo is "
  url -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  CHECK_STAT $?

  PRINT "Installing NodeJS"
  yum install nodejs -y &>>${LOG}
  CHECK_STAT $?

  APP_COMMON_SETUP

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
  mv /home/roboshop/cart/systemd.service /etc/systemd/system/${COMPONENT}.service &>>{log} && systemctl daemon-reload
  CHECK_STAT $?



  PRINT "Start ${COMPONENT} service"
  systemctl enable ${COMPONENT} &>>${LOG} && systemctl restart ${COMPONENT} &>>${LOG}
  CHECK_STAT $?
SYSTEMD

}

NGINX() {
  PRINT "Installing Nginx"
  yum install nginx -y &>>${LOG}
  CHECK_STAT $?

  PRINT "Download ${COMPONENT} Content"
  curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip"
  CHECK_STAT $?

  PRINT "Clean OLD Content"
  cd/usr/share/nginx/html
  rm -rf * &>>${LOG}
  CHECK_STAT $?

  PRINT "Exrtact ${COMPONENT} content"
  unzip /tmp/${COMPONENT}.zip
  CHECK_STAT $?

  PRINT "Organize ${COMPONENT} Component"
  mv ${COMPONENT}-main/* . && mv static/* . && rm -rf ${COMPONENT}-main README.dm && mv localhost.conf /etc/nginx/default.d/roboshop.conf
  CHECK_STAT $?

  PRINT "update ${COMPONENT} Configuration"
  sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal1976/' -e '/user/ s/localhost/user.roboshop.internal1976/' -e '/cart/ s/localhost/cart.roboshop.internal1976/'
  -e '/payment/ s/localhost/payment.roboshop.internal1976/' -e '/shipping/ s/localhost/shipping.roboshop.internal/'
  /etc/nginx/default.d/robpshop.conf
  CHECK_STAT $?

  PRINT "Restart Nginx Service"
  systemctl enable nginx  &>>${LOG} && systemctl restart nginx  &>>${LOG}
  CHECK_STAT $?


}
MAVEN() {
  CHECK_ROOT
  PRINT "Installing Maven"
  yum install maven -y
  CHECK_STAT $?

  useradd roboshop
  cd /home/roboshop
  rm -rf shipping
  curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"
  unzip /tmp/shipping.zip
  mv shipping-main shipping
  cd shipping
  mvn clean package
  mv target/shipping-1.0.jar shipping.jar
  sed -i -e 's/CARTENDPOINT/cart.roboshop.internal1976/' -e 's/DBHOST/mysql.roboshop.internal1976/' /home/roboshop/shipping/sysytemd.service

  mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
  systemctl daemon-reload
  systemctl start shipping
  systemctl enable shipping
}