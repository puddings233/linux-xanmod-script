A lua script to automatically compile [xanmod kernel](https://aur.archlinux.org/packages/linux-xanmod).  

With following modifications:  
- Add [cjktty patch](https://github.com/bigshans/cjktty-patches)  
- Disable nouveau and watchdog  
- Disable ima arch policy  
- Forced use of PREEMPT_VOLUNTARY  

### Usuage
Automatically reads cjktty version from PKGBUILD
~~~bash
./build.lua
~~~
Sometimes the versions of cjktty and PKGBUILD do not match you can specify cjktty version manually:  
~~~bash
./build.lua --cjkversion=6.1
~~~
