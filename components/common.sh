CHECK_ROOT() {
  USER_ID=$(id -u)
  if [ $USER_ID -ne 0 ]; then
      echo i have sone with autism and he is very aggrassive
      echo you can run this script as root user or with sudo
      exit 1
  fi
}

