echo Checking Node.js install...

if node --version &> /dev/null
then
  echo Node installed. 
else
  echo ---
  echo
  echo Node has not been installed: 
  echo Please Google and install \"Node.js\"
  echo Or go to http://nodejs.org/download/
  echo
  exit 0
fi

echo Checking for Jekyll...
if jekyll --version &> /dev/null
then
  echo Jekyll installed. 
else
  echo
  echo Jekyll not detected
  echo
  echo Installing Jekyll:
  # If sudoed
  if [ "$(id -u)" == "0" ]
  then
    echo
    gem install jekyll || (echo "Error installing Jekyll" && exit -1)
  else
    echo Error: Please rerun this script using \"sudo\".
    echo I.e. \"sudo ./setup.sh\"
    exit -1
  fi
fi
echo Done
echo

echo Installing grunt packages...
npm install || (echo Error installing packages. Please run \"npm install\" manually to debug, then run this script again. && exit -2)
echo Done
echo

echo Setting up server details...
echo
chmod +x key-setup.sh

if ./key-setup.sh
then
  echo
  echo Done. 
  echo
  echo Run \"npm run publish\" to upload any changes to the website. 
fi