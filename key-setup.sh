if [ -r .settings ] && [ -r .key ]
then
  echo "Server appears to already be setup. Would you like to erase the current settings? (y/n)"
  read yn
  if [ "$yn" == "y" ] || [ "$yn" == "Y" ]
  then
    rm .settings
    rm .key
    
    echo "Settings erased"
    echo ""
    
    ./setupKey.sh
  fi
  
else
  
  echo "Enter the remote server:"
  read server
  
  echo "Enter the remote username:"
  read user
  
  echo "Enter the remote path: (probably public_html/)"
  read path
  
  # Save these settings in JSON format
  echo "{ \"server\": \"$server\", \"user\": \"$user\", \"path\": \"$path\" }" > .settings.json
  
  echo "Generating and uploading keys for remote access. Keys will be saved to "".key""."
  echo "Guard these files as they give unrestricted access to your webspace!"
  echo ""
  echo "Please enter remote password when prompted..."
  
  # Command to create the authorized_keys file if needed, ensure the correct permissions and then add our key to it. 
  command="mkdir -p ~/.ssh; chmod 0700 ~/.ssh; touch ~/.ssh/authorized_keys; chmod 0600 ~/.ssh/authorized_keys; cat >> ~/.ssh/authorized_keys"

  keyFile=".key"
  comment="Generated keyfile for website deployment"

  # Generate key
  ssh-keygen -q -P "" -C "$comment" -f ./$keyFile
  
  # Upload it
  cat ./$keyFile.pub | ssh $user@$server "$command"
  
  echo "Done"
fi