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