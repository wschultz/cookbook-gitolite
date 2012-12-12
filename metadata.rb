maintainer       "Wil Schultz"
maintainer_email "wschultz@bsdboy.com"
license          "Apache 2.0"
description      "Installs/Configures gitolite3"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.3"

%w{ git }.each do |cb|
  depends cb
end
 
