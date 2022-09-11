yum install maven -y
useradd roboshop
cd /home/roboshop
rm -rf shipping
curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"
unzip /tmp/shipping.zip
mv shipping-main shipping
cd shipping
mvn clean package
mv target/shipping-1.0.jar shipping.jar
sed -i -e 's/CARTENDPOINT/cart.robohsop.internal1976/' -e 's/DBHOST/mysql.roboshop.internal1976/' /home/roboshop/shipping/sysytemd.service

mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
systemctl daemon-reload
systemctl start shipping
systemctl enable shipping