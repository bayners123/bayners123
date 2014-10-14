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
if jekyll --version
then
  echo Jekyll installed. 
else
  echo jekyll not detected
  echo
  echo Installing Jekyll:
  echo
  gem install jekyll
fi
  

echo Installing grunt packages...
npm install

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