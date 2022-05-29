#!/bin/sh
if [ "$1" ]
then
  file_path=$1
  file_name=$(basename "$file_path")
  DEVICE=$(echo $TARGET_PRODUCT | sed 's/aniosp_//g')
  if [ -f $file_path ]; then
    file_size=$(stat -c%s $file_path)
    sha1=$(cat "$file_path.sha1sum" | cut -d' ' -f1)
    datetime=$(grep ro\.build\.date\.utc ./out/target/product/$DEVICE/system/build.prop | cut -d= -f2);
    id=$(sha256sum $file_path | awk '{ print $1 }');
    echo "{\n   \"datetime\": $datetime,\n   \"filehash\": \"$sha1\",\n   \"filename\": \"$file_name\",\n   \"id\": \"$id\",\n   \"size\": $file_size\n}" > $file_path.json
  fi
fi
