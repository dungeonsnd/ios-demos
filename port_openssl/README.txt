
已经移植完成。但是还没时间去测。
笔者在参考了其他开发者资料用了build-libssl.sh这个脚本来编译成功的， 笔者作了如下修改：


1) 下面这一行来启用 BITCODE，笔者增加了 -fembed-bitcode。 暂时不知道是否启用成功。
    sed -ie "s!^CFLAG=!CFLAG=-isysroot ${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk -fembed-bitcode !" "Makefile"


TODO: 
1) 写个demo来测试基本功能，如 aes，sha1sum, rsa, base64, md5等。



参考资源:
https://github.com/OnionBrowser/iOS-OnionBrowser/blob/master/build-libssl.sh
http://www.oschina.net/question/54100_36169

