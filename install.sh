#!/bin/sh
DIR=$(realpath $1)
mkdir -p $DIR
ENGINE=$DIR/engine
mkdir -p $ENGINE
cd engine
./build.sh
cp *.o exec.sh $ENGINE/
sed -i "s#DIR#$DIR#g" $ENGINE/exec.sh
WEB=$DIR/web-interface
mkdir -p $WEB
cd ../web-interface
cp -r package.json www-api-lhd2018.service index.js views $WEB/
cd $WEB
npm i
sed -i "s#NODE_PATH#$(which node)#g;s#DIR#$DIR#g" www-api-lhd2018.service
systemctl link $(realpath www-api-lhd2018.service)
