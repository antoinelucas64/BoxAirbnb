
#!/bin/bash

export INBOX=tmp
mkdir tmp
echo "ON" > tmp/a_b_c_+336xxxyyyy

../src/script/parseSMS.sh

echo "ON" > tmp/a_b_c_+337xxxyyyy

../src/script/parseSMS.sh

echo "ON" > tmp/a_b_c_+336aaayyyy

../src/script/parseSMS.sh

rmdir  tmp
