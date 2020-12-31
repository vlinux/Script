#!/bin/bash
url=http://dldir1.qq.com/kpgs/cdn/
env=$1
version=$2
case $1 in
    yfb)
        curl -sO http://dldir1.qq.com/kpgs/cdn/preview/${version}/assets.manifest
        for i in `cat assets.manifest | grep ": {" | awk -F '"' '{print $2}'| grep -v "assets"` ; do
        HTTP_CODE=`curl -o /dev/null -s -w %{http_code} http://dldir1.qq.com/kpgs/cdn/preview/${version}/${i}`
          if [[  "$HTTP_CODE" == "404"  ]]
            then
            echo -e ${i} 文件不存在
          fi
     done
     rm -rf assets.manifest && echo -e 预发布服${version}CDN文件验证完毕
        ;;
    zsf)
        curl -sO http://dldir1.qq.com/kpgs/cdn/preview/${version}/assets.manifest
        for i in `cat assets.manifest | grep ": {" | awk -F '"' '{print $2}'| grep -v "assets"` ; do
        HTTP_CODE=`curl -o /dev/null -s -w %{http_code} http://dldir1.qq.com/kpgs/cdn/txcm/${version}/${i}`
          if [[  "$HTTP_CODE" == "404"  ]]
            then
            echo -e ${i} 文件不存在
          fi
     done
     rm -rf assets.manifest && echo -e 正式服${version}CDN文件验证完毕
        ;;
    *)
        echo "使用说明: bash $0 {yfb|zsf} {version}"
esac
