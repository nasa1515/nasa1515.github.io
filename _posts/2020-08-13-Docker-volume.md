---
layout: post
title: "[DOCKER] - VOLUMES"
author: nasa1515
categories: DOCKER
date: 2020-08-13 13:55
comments: true
tags: [DOCKER]
cover: https://res.cloudinary.com/yangeok/image/upload/v1593160497/logo/posts/iot-protocol.jpg
---



# [DOCKER] -  VOLUMES

**머리말**  
 이전 포스트에서는 도커 컨테이너의 전반적인 운영법에 대해서 포스팅 했었다.  
 이번 포스트에서는 볼륨을 이용해서 실제 도커의 데이터 관리 방법과  
 그와 관련된 명령어들을 포스트 했다.


---


**목차**
- [도커 볼륨](#a1)
- [BIND MOUNT 사용](#a2)
- [VOLUME 사용](#a3)

---


## 도커 볼륨 <a name="a1"></a>  

기본적으로 컨테이너에 생성되는 모든 파일은 컨테이너 레이어에 저장됩니다.  
이 데이터들은 컨테이너와 함께 삭제되는 런타임 데이터인데 ``(휘발성)``  
이 데이터를 영구적으로 저장하려면 반드시 ``볼륨``을 사용해야 합니다.

**도커의 볼륨-마운트 구조**  

![](https://t1.daumcdn.net/cfile/tistory/99839A4A5DC803CC28)

* **도커에서 볼륨을 사용하는 방법은 두가지가 있습니다.**

* **1. ``Bind Mount``**  
초기 도커부터 사용했던 방식이다.  
호스트의 특정 디렉토리와 컨테이너의 디렉토리를 연결하는 방식이다.  
**bind mount는 쉽게 사용할 수 있지만 도커에 의해 관리되지 않기 때문에  
따로 기록 해놓지 않으면 관리하기가 어렵다**  

* **Bind Mount 사용 사례**
    * **호스트와 컨테이너가 /etc/resolv.conf 와 같은 설정 파일을 공유할 때**
    * **호스트와 컨테이너가 개발환경 사이에서 소스 코드나 빌드 아티팩트를 공유할 때**
    * **호스트의 파일 또는 디렉토리 구조가 컨테이너의 BIND MOUNT와 일치하도록 보장된 경우**

* **도커의 호스트 볼륨 디렉토리에 마운트 하는 로직**
    ![](https://t1.daumcdn.net/cfile/tistory/99FA9B3B5B88FAF119)

    * 이 방법은 container의 데이터를 호스트에 유지할 때 사용할 수 있음

    * 하지만 Volume이 /var/lib/docker/volumes/에 생기며  
    이름이 docker에서 자동으로 생성한 hash값을 사용

    * container가 삭제되면 데이터를 찾기 힘들기 때문에 추천하지 않음

    ```
    $ docker run -it -v /data centos /bin/bash
    $ docker run -it -v (컨테이너의 volume 디렉토리) (이미지) /bin/bash
    ```

*  **이를 통해 컨테이너를 생성 시**

    - /var/lib/docker/volumes에 hash값을 가지는 디렉토리가 생성되고,  
    _data 디렉토리 안에 컨테이너의 /data 디렉토리가 매핑

    - 즉, 컨테이너에서 /data 디렉토리에 파일을 생성/삭제/변경 등의 작업을 하게되면,  
    호스트의 /var/lib/docker/volumes/xxxx 디렉토리에 같은 내용이 있음

----

* **도커의 득정 디렉토리와 마운트 하는 로직**
    ![](https://t1.daumcdn.net/cfile/tistory/995CFD335B88FACB13)


    - 이 방법을 사용하면 호스트의 특정 디렉토리(or 파일)을 container와 매핑

    - Volume의 위치를 사용자가 정할 수 있으므로 데이터를 찾기 쉬움

    ```
    $ docker run -it -v /root/data:/data centos /bin/bash
    $ docker run -it -v (호스트 디렉토리):(컨테이너의 volume 디렉토리) (이미지) /bin/bash
    ```

* **위의 명령어는 호스트의 /root/data 디렉토리를  
    container의 volume 디렉토리로 사용할 수 있도록 한다.**  


    - 호스트에서 /root/data 디렉토리에 파일을 생성하게 된다면,  
    container에서도 파일이 존재하고 사용할 수 있다.  

    - 반대의 경우(container에서 파일을 생성)에도 호스트에서 파일이 존재한다.

----

* **2. ``VOLUME``**  
도커에 의해 관리되는 스토리지이다.  
docker 명령어를 사용하여 생성할 수 있고 한번에 삭제도 가능하다.  
볼륨은 BIND MOUNT와 다르게 다양한 드라이버를 지원하고 있다.  

* **VOLUME 사용 사례**
    * **다수의 실행 중인 컨테이너 사이에 데이터를 공유할 때**
    * **컨테이너에서 호스트 구성을 분리할 때**
    * **컨테이너 데이터를 원격의 호스트 또는 클라우드 업체에 저장할 때**
    * **다른 호스트로 데이터를 백업하거나 복원할 때**


    ![](https://t1.daumcdn.net/cfile/tistory/9942AE3F5B88FB0C0E)

    ```
    $ docker run -it --name container1 -v /root/data:/data centos /bin/bash
    $ docker run -it --name container2 -v /root/data:/data centos /bin/bash
    ```

    * **container1의 /data 디렉토리와 container2의 /data 디렉토리를 호스트의 /root/data 디렉토리와 매핑 함으로써**

    * 각 각의 container에서 호스트의 디렉토리(파일)을 공유 가능


---

* **추가적인 도커(Docker) Volume 사용법 ``(파일 하나를 컨테이너에 연결)``**

    * 디렉토리 뿐만 아니라 호스트의 파일 하나도 container와 매핑이 가능하다.


    ```
    $ docker run -it -v /root/test.txt:/root/test.txt centos /bin/bash
    $ docker run -it -v (호스트 파일):(컨테이너의 파일) centos /bin/bash
    ```

-----

## 2. BIND MOUNT 사용   <a name="a2"></a>  

* **BIND MOUNT를 사용하기 위해 먼저 디렉토리와 파일을 생성한다.**
   
    ```
    nasa1515@nasa:/$ mkdir ~/nasa1515; touch ~/nasa1515/nasatest.txt
    nasa1515@nasa:/$ ls -l ~/nasa1515/
    합계 0
    -rw-r--r-- 1 student student 0  8월 17 15:55 nasatest.txt   
    ```

* **실행 중인 컨테이너에는 Bind Mount를 연결할 수 없고,  
반드시 컨테이너를 실행하거나, 생성하면서 연결해야한다.**  
``[-v]`` 옵션을 사용하여 컨테이너와 연결할 수 있다.  

    ```
    nasa1515@nasa:~$ docker run -itd --name bind -v ~/nasa1515:/tmp/mount centos:latest
    81949e2f5ea976f3dbd1f48c517a94298295054ed8d099fae86809dccf2efa18
    nasa1515@nasa:~$ 
    nasa1515@nasa:~$ 
    nasa1515@nasa:~$ docker exec bind ls /tmp/mount
    nasatest.txt
    nasa1515@nasa:~$ 
    ```
----


## 3. VOLUME 사용   <a name="a3"></a>  

* **볼륨은  ``docker volume`` 명령으로 생성할 수 있다.**  
해당 볼륨들은 ``/var/lib/docker/volumes``에 저장된다.  

    ```
    $ docker volume create --help

    Usage: docker volume create [OPTIONS] [VOLUME]
    ...
    ```

* **``nasa-volume``을 생성해보겠다.**
    
    ```
    student@cccr:~$ docker volume create nasa-volume
    nasa-volume
    ```

* **``docker volume ls`` 명령어로 호스트의 볼륨 리스트를 확인할 수 있다.**

    ```
    student@cccr:~$ docker volume ls | grep nasa
    DRIVER              VOLUME NAME
    local               nasa-volume
    ```

* **``docker inspect`` 명령어로 볼륨이 연결되어있는 호스트의 정보를 알 수 있다.**

    ```
    student@cccr:~$ docker inspect nasa-volume
    [
        {
            "CreatedAt": "2020-08-17T16:38:04+09:00",
            "Driver": "local",
            "Labels": {},
            "Mountpoint": "/var/lib/docker/volumes/nasa-volume/_data",
            "Name": "nasa-volume",
            "Options": {},
            "Scope": "local"
        }
    ]
    ```

* **BIND MOUNT와 마찬가지로 도커 볼륨도 컨테이너를 실행하거나 생성하면서 연결해야함**  
    ``nasa-vol-centos``라는 이름의 컨테이너에 연결해보겠다.
    
    ```
    student@cccr:~$ docker run -itd --name nasa-vol-centos -v nasa-volume:/tmp/volume centos:latest
    c701b353eab422ee6ff88d81ddc67d8afff7f9cee2d90327fa034f4e2d2f42bc
    ```
    현재 볼륨에는 데이터가 없기때문에 컨테이너를 확인해도 아무것도 없을 것이다.  

* **httpd 컨테이너를 볼륨에 연결하여 파일을 연동해보겠다.**

    ```
    student@cccr:~$ docker run -d --name nasa-web -v nasa-volume:/usr/local/apache2/htdocs:ro httpd:latest
    Unable to find image 'httpd:latest' locally
    latest: Pulling from library/httpd
    bf5952930446: Already exists 
    3d3fecf6569b: Pull complete 
    b5fc3125d912: Pull complete 
    679d69c01e90: Pull complete 
    76291586768e: Pull complete 
    Digest: sha256:3cbdff4bc16681541885ccf1524a532afa28d2a6578ab7c2d5154a7abc182379
    Status: Downloaded newer image for httpd:latest
    d9c599d077832ff83f51695ad09f6c14446e2d61d7418c50f4645973714e9b03
    ```
    ``httpd:latest`` 이미지로 생성된 컨테이너는 ``/usr/local/apache2/htdocs``디렉토리에  
    index.html 파일이 존재한다.  
    볼륨이 성공적으로 연결되었다면 처음 생성한 컨테이너에서도 index.html 파일이 보여야한다.  


* **볼륨 공유 확인**

    ```
    student@cccr:~$ docker exec nasa-vol-centos cat /tmp/volume/index.html
    <html><body><h1>It works!</h1></body></html>
    ```
    **볼륨이 성공적으로 연결되어 해당 컨테이너에서도 확인이 가능하다.**

---