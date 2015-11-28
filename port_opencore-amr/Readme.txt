
Refer to
http://www.ifun.cc/blog/2015/10/23/bian-yi-opencore-amr-for-ios8bing-zhi-chi-bitcode/ 
https://github.com/feuvan/opencore-amr-iOS

lib-opencore-amr-ios.tar.xz is the result binaries compiled by myself.
Use tar Jxvf lib-opencore-amr-ios.tar.xz to uncompress.
Have fun!
笔者将自己编译的启动bitcode的静态库用在一个demo中，并在真机上录音转换成功，这些测试的真机包含 iphone5s （ arm64）/iphone4s(armv7)/itouch5。所以猜测适配所有机型。


opencore-amr-0.1.3的编译方法

1 下载
从 http://sourceforge.net/projects/opencore-amr/ 下载开源的 opencore-amr .

2 编译
使用脚本 build-opencore-amr-enable-bitcode.sh 编译, 注意其中的 -fembed-bitcode 是用来启用bitcode的。如果不启用，那么使用者将无法编译通过，除非使用者把他自己项目中的bitcode禁用，而这对使用者非常不友好。

编译好之后会产生如下文件，把其中的头文件include目录、libopencore-amrnb.a和libopencore-amrwb.a复制给使用者即可。arm格式分为两类，即nb和wb，nb是压缩格式。xxnb.a是合并后的amr-nb格式，xxwb.a是合并后的amr-wb格式。建议直接把libopencore-amrnb.a和libopencore-amrwb.a引入项目中。
类似libopencore-amrnb.a.arm64是某一cpu平台的库，使用时可直接使用合并好的库，如libopencore-amrnb.a。

[jefMBP 06:54:22 ~/file/code/gitsrc/ios-demos/port_opencore-amr]$ll lib-opencore-amr-ios/include/
total 0
drwxr-xr-x  4 jeffery  staff   136B 11  4 14:28 opencore-amrnb
drwxr-xr-x  4 jeffery  staff   136B 11  4 14:28 opencore-amrwb
[jefMBP 06:54:28 ~/file/code/gitsrc/ios-demos/port_opencore-amr]$
[jefMBP 06:54:29 ~/file/code/gitsrc/ios-demos/port_opencore-amr]$ll lib-opencore-amr-ios/lib/
total 25744
-rw-r--r--  1 jeffery  staff   4.6M 11  4 14:28 libopencore-amrnb.a
-rw-r--r--  1 jeffery  staff   927K 11  4 14:26 libopencore-amrnb.a.arm64
-rw-r--r--  1 jeffery  staff   919K 11  4 14:25 libopencore-amrnb.a.armv7
-rw-r--r--  1 jeffery  staff   930K 11  4 14:26 libopencore-amrnb.a.armv7s
-rw-r--r--  1 jeffery  staff   931K 11  4 14:27 libopencore-amrnb.a.i386
-rw-r--r--  1 jeffery  staff   986K 11  4 14:28 libopencore-amrnb.a.x86_64
-rwxr-xr-x  1 jeffery  staff   968B 11  4 14:28 libopencore-amrnb.la
-rw-r--r--  1 jeffery  staff   1.7M 11  4 14:28 libopencore-amrwb.a
-rw-r--r--  1 jeffery  staff   350K 11  4 14:26 libopencore-amrwb.a.arm64
-rw-r--r--  1 jeffery  staff   335K 11  4 14:25 libopencore-amrwb.a.armv7
-rw-r--r--  1 jeffery  staff   340K 11  4 14:26 libopencore-amrwb.a.armv7s
-rw-r--r--  1 jeffery  staff   342K 11  4 14:27 libopencore-amrwb.a.i386
-rw-r--r--  1 jeffery  staff   363K 11  4 14:28 libopencore-amrwb.a.x86_64
-rwxr-xr-x  1 jeffery  staff   968B 11  4 14:28 libopencore-amrwb.la
drwxr-xr-x  4 jeffery  staff   136B 11  4 14:28 pkgconfig


3 参考资料
http://blog.csdn.net/justinjing0612/article/details/9633121
http://www.oschina.net/code/snippet_562429_12400
http://my.oschina.net/jeans/blog/69937
http://blog.csdn.net/devday/article/details/6804553
http://blog.sina.com.cn/s/blog_a3059cda0102vauc.html


