yum install python36 gcc python3-devel -y
seradd roboshop
cd /home/roboshop
rm -rf payment
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip"
unzip /tmp/payment.zip
mv payment-main payment
mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service
systemctl daemon-reload
systemctl enable payment
systemctl start payment