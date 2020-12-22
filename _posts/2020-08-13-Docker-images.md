---
layout: post
title: "[DOCKER] - 이미지 관리"
author: Lee Wonseok
categories: DOCKER
date: 2020-08-13 10:55
comments: true
tags: [DOCKER]
cover: https://res.cloudinary.com/yangeok/image/upload/v1593160497/logo/posts/iot-protocol.jpg
---



# [DOCKER]  이미지 관리

**머리말**  
 이전 포스트에서는 도커의 설치방법에 대해서 간단하게 포스팅 했었다.  
 이번 포스트에서는 실제 도커의 컨테이너의 생성 관리 방법 및 명령어들을 포스트 했다.


---


**목차**
- [도커 이미지](#a1)
- [도커 이미지 명령어](#a2)
- [도커 허브를 통한 이미지 업로드, 다운로드](#a3)

---

## 도커 이미지 <a name="a1"></a>  

* 도커는 기본적으로 ``도커 허브``라고 하는 중앙 이미지 저장소에서 이미지를 내려받습니다.  
도커 허브는 도커가 공식적으로 제공하고 있는 이미지 저장소로 쉽게 올리고 내려받을 수 있습니다.


    ![](https://miro.medium.com/max/1104/1*ttU6oMoZztKk2kjJid6PuQ.png)


* **Docker Hub**  
    도커 허브는 도커에서 제공하는 기본 이미지 저장소로 ubuntu, centos, debian등의 베이스 이미지와  
    ruby, golang, java, python 등의 공식 이미지가 저장되어 있습니다.  
    일반 사용자들이 만든 이미지도 50만 개가 넘게 저장되어 있고 다운로드 횟수는 80억 회를 넘습니다.

    회원가입만하면 대용량의 이미지를 무료로 저장할 수 있고  
    다운로드 트래픽 또한 무료입니다.  
    단, 기본적으로 모든 이미지는 공개되어 누구나 접근 가능하므로 비공개로 사용하려면 유료 서비스를 이용해야 합니다.

* **회원가입**  
    아래 링크에서 Dokcer hub 회원 가입 후 포스트를 읽는 것을 추천드립니다!!.  
   https://hub.docker.com/  

![](https://subicura.com/assets/article_images/2017-02-10-docker-guide-for-beginners-create-image-and-deploy/docker-hub.png)

---

## 도커 이미지 명령어 <a name="a2"></a>  

* **``docker images``** 명령어를 사용해 현재 HOST가 가지고 있는 이미지를 확인 할 수 있다. 

    ```
    nasa1515@nasa:~$ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED                 SIZE
    hello-world         latest              bf756fb1ae65        7 months ago            13.3kB
    ```
    이전 포스트에서 ``hello-world`` 컨테이너를 실행하여 남아 있는 것을 확인.

---

* **``docker search``** 명령어를 사용해 docker hub에 존재하는 이미지를 검색 할 수 있습니다.  
    우선 centos os를 한번 검색해보겠습니다.  

    ```
    nasa1515@nasa:~$ docker search centos
    NAME                               DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
    centos                             The official build of CentOS.                   6134                [OK]                
    ansible/centos7-ansible            Ansible on Centos7                              132                                     [OK]
    consol/centos-xfce-vnc             Centos container with "headless" VNC session…   119                                     [OK]
    jdeathe/centos-ssh                 OpenSSH / Supervisor / EPEL/IUS/SCL Repos - …   115                                     [OK]
    centos/systemd                     systemd enabled base container.                 87                                      [OK]
    centos/mysql-57-centos7            MySQL 5.7 SQL database server                   80                                      
    imagine10255/centos6-lnmp-php56    centos6-lnmp-php56                              58                                      [OK]
    ...... (중략)    
    ```



    * **이미지 필드에 대한 설명은 다음과 같습니다.**
        *  ``NAME`` : 이미지 저장소의 이름
        *  ``DESCRIPTION`` : 이미지에 대한 설명
        *  ``STATS`` : 이미지에 대한 평가점수
        *  ``OFFICIAL`` : 공식 이미지 여부
        *  ``AUTOMATED`` : 자동화 빌드 여부

---

* **``docker pull``** 명령어를 사용해 docker hub에 존재하는 이미지를 다운로드 할 수 있습니다.  
    명령어의 사용법은 아래와 같습니다.

    ```
    $ docker pull --help


    Usage: docker pull [OPTION] NAME[:TAG|@DIGEST]
    ```

    *  NAME: search 명령의 결과의 name과 동일합니다.  
    *  추가로 ``TAG``, ``@DIGEST``를 사용하는데 이는 저장소의 실제 이미지를 구분하는 것입니다.  
    *  ``TAG`` : 보통 버전을 나타내거나 특성을 나타냅니다.
    *  ``@DIGEST`` : 해시처럼 이미지의 무결성을 검증하는데 사용합니다.  
    *  두개의 옵션을 모두 생략한다면 자동으로 TAG에 ``latest``가 부여되어 다운로드 됩니다.


* **우선 centos os를 TAG없이 한번 받아오겠습니다.**  
    
    ```
    nasa1515@nasa:~$ docker pull centos
    Using default tag: latest
    latest: Pulling from library/centos
    3c72a8ed6814: Pull complete 
    Digest: sha256:76d24f3ba3317fa945743bb3746fbaf3a0b752f10b10376960de01da70685fbd
    Status: Downloaded newer image for centos:latest
    docker.io/library/centos:latest

    nasa1515@nasa:~$ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    centos              latest              0d120b6ccaa8        6 days ago          215MB
    hello-world         latest              bf756fb1ae65        7 months ago        13.3kB
    ```

* **이번에는 TAG를 ``mysql:5.7``로 부여 후 mysql을 받아와 보겠습니다.**  

    ```
    nasa1515@nasa:~$ docker pull mysql:5.7
    5.7: Pulling from library/mysql
    bf5952930446: Pull complete 
    8254623a9871: Pull complete 
    938e3e06dac4: Pull complete 
    ea28ebf28884: Pull complete 
    f3cef38785c2: Pull complete 
    894f9792565a: Pull complete 
    1d8a57523420: Pull complete 
    5f09bf1d31c1: Pull complete 
    1b6ff254abe7: Pull complete 
    74310a0bf42d: Pull complete 
    d398726627fd: Pull complete 
    Digest: sha256:da58f943b94721d46e87d5de208dc07302a8b13e638cd1d24285d222376d6d84
    Status: Downloaded newer image for mysql:5.7
    docker.io/library/mysql:5.7
    student@cccr:~$ 
    nasa1515@nasa:~$ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    centos              latest              0d120b6ccaa8        6 days ago          215MB
    mysql               5.7                 718a6da099d8        12 days ago         448MB
    hello-world         latest              bf756fb1ae65        7 months ago        13.3kB
    ```
----

* **``docker rmi``** 명령어를 사용해 Host 저장소에 존재하는 이미지를 삭제 할 수 있습니다.  
    명령어의 사용법은 아래와 같습니다.

    ```
    $ docker rmi --help

    Usage:  docker rmi [OPTIONS] IMAGE  [IMAGE...]
    ...
    ```

* **방금 다운로드 받았던 mysql 이미지를 삭제 해보겠습니다.**  

    ```
    nasa1515@nasa:~$ docker rmi mysql:5.7
    Untagged: mysql:5.7
    Untagged: mysql@sha256:da58f943b94721d46e87d5de208dc07302a8b13e638cd1d24285d222376d6d84
    Deleted: sha256:718a6da099d82183c064a964523c0deca80619cb033aadd15854771fe592a480
    Deleted: sha256:058d93ef2bfb943ba6a19d8b679c702be96e34337901da9e1a07ad62b772bf3d
    Deleted: sha256:7bca77783fcf15499a0386127dd7d5c679328a21b6566c8be861ba424ac13e49
    Deleted: sha256:183d05512fa88dfa8c17abb9b6f09a79922d9e9ee001a33ef34d1bc094bf8f9f
    Deleted: sha256:165805124136fdee738ed19021a522bb53de75c2ca9b6ca87076f51c27385fd7
    Deleted: sha256:904abdc2d0bea0edbb1a8171d1a1353fa6de22150a9c5d81358799a5b6c38c8d
    Deleted: sha256:d26f7649f78cf789267fbbca8aeb234932e230109c728632c6b9fbc60ca5591b
    Deleted: sha256:7fcf7796e23ea5b42eb3bbd5bec160ba5f5f47ecb239053762f9cf766c143942
    Deleted: sha256:826130797a5760bcd2bb19a6c6d92b5f4860bbffbfa954f5d3fc627904a76e9d
    Deleted: sha256:53e0181c63e41fb85bce681ec8aadfa323cd00f70509107f7001a1d0614e5adf
    Deleted: sha256:d6854b83e83d7eb48fb0ef778c58a8b839adb932dd036a085d94a7c2db98f890
    Deleted: sha256:d0f104dc0a1f9c744b65b23b3fd4d4d3236b4656e67f776fe13f8ad8423b955c
    nasa1515@nasa:~$ 
    nasa1515@nasa:~$ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    centos              latest              0d120b6ccaa8        6 days ago          215MB
    hello-world         latest              bf756fb1ae65        7 months ago        13.3kB
    ```
    MYSQL 이미지와 관련된 ``레이어``는 전부 삭제하며  
    해당 레이어를 다른 컨테이너 또는 이미지가 ``사용하고 있다면`` 삭제하지 않는다.


* **test를 위해 rmitest라는 이름의 hello-world 이미지를 사용한 컨테이너를 하나 생성합니다.**
    
    ```
    nasa1515@nasa:~$ docker run -itd --name rmitest hello-world
    701ad267fbc8aca292b033d424e6a295f06f410ae80807d8b124e15efa021685
    --------------------------------------------------------------------------------------------
    nasa1515@nasa:~$ docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS                          PORTS               NAMES
    701ad267fbc8        hello-world         "/hello"            About a minute ago   Exited (0) About a minute ago                       rmitest
    --------------------------------------------------------------------------------------------
    nasa1515@nasa:~$ docker rmi hello-world
    Error response from daemon: conflict: unable to remove repository reference "hello-world" (must force) - container 701ad267fbc8 is using its referenced image bf756fb1ae65
    ```
    다음과 같이 사용중인 이미지의 경우 삭제가 되지 않는다.  
    이 경우에는 ``-f 옵션``을 사용하면 삭제 할 수 있지만 실행중인 컨테이너에게 영향을 미치기에 권장하지는 않는다.

----

* **``docker inspect``** 명령어를 사용해 docker 오브젝트의 정보를 자세히 확인 할 수 있습니다.  
    명령어의 사용법은 아래와 같습니다.

    ```
    $ docker inspect --help

    Usage: docker inspect [OPTIONS] NAME|ID [NAME|ID...]
    ...
    ```

* **inspect 명령어로 centos 이미지의 정보를 확인해보자.**

    ```
    nasa1515@nasa:~$ docker inspect centos:latest
    ...
            "Config" : {
                ...
                "CMD" : [
                    "/bin/bash"
                ],
                ...
                "Volumes": null,
                "WorkinDir": "",
                "Entrypoint" : null,
            ...
            "RootFS" : {
                "Type" : "layers",
                "Layers" : [
                
            "sha256:0d120b6ccaa8c5e149176798b3501d4dd1885f961922497cd0abef155c869566"
    ...
    ```
    출력된 부분 중 이후 포스트에서 필요한 부분만 나열하였다.  

    - ``Config`` : 섹션의 cmd는 이미지를 컨테이너로 생성할 때 실행하는 애플리케이션이다.
    - ``Volumes``: 도커 볼륨과 관련된 내용이다. 
    - ``WorkingDir`` : 컨테이너에 접근했을 때의 디렉토리
    - ``Entrypoint`` : cmd와 마찬가지고 실행 할 애플리케이션이다 cmd와 Entry가 함께 있으면  
    Entry는 ``명령``, cmd는 ``인자``처럼 동작한다.
    - ``RootFS`` : 레이어를 나타낸다. 

---

* **``docker save/load``**  명령어를 사용해 호스트에 저장된 이미지를 복사, 불러올 수 있습니다.  
    명령어의 사용법은 아래와 같습니다.

    ```
    $ docker save --help

    Usage: docker save [OPTIONS] IMAGE [IMAGE...]
    ...

    # docker load --help

    Usage: docker load [OPTIONS]
    ...
    ```

* **docker save 명령은 ``-o 옵션``을 사용해 파일의 경로를 지정해야한다.**

    centos 이미지를 아카이브 파일로 복사하고 내용을 확인해보았다.
    ```
    nasa1515@nasa:~$ docker save -o img.tar centos:latest
    nasa1515@nasa:~$ 
    nasa1515@nasa:~$ tar tf img.tar
    0d120b6ccaa8c5e149176798b3501d4dd1885f961922497cd0abef155c869566.json
    42f3938b740e458a1d119b6af08468e05a60bce967245f990cf205b99d7b2eee/
    42f3938b740e458a1d119b6af08468e05a60bce967245f990cf205b99d7b2eee/VERSION
    42f3938b740e458a1d119b6af08468e05a60bce967245f990cf205b99d7b2eee/json
    42f3938b740e458a1d119b6af08468e05a60bce967245f990cf205b99d7b2eee/layer.tar
    manifest.json
    repositories
    ```

* **save한 이미지를 테스트 하기 위해 기존에 설치되어 있는 이미지를 삭제한다**

    ```
    nasa1515@nasa:~$ docker rmi hello-world httpd centos
    Untagged: centos:latest
    Untagged: centos@sha256:76d24f3ba3317fa945743bb3746fbaf3a0b752f10b10376960de01da70685fbd
    Deleted: sha256:0d120b6ccaa8c5e149176798b3501d4dd1885f961922497cd0abef155c869566
    Deleted: sha256:291f6e44771a7b4399b0c6fb40ab4fe0331ddf76eda11080f052b003d96c7726

    nasa1515@nasa:~$ 
    nasa1515@nasa:~$ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    ```

* **아카이브 파일로 이미지를 로드 후 확인**

    ```
    nasa1515@nasa:~$ docker load -i img.tar 
    291f6e44771a: Loading layer [==================================================>]  222.4MB/222.4MB
    Loaded image: centos:latest
    nasa1515@nasa:~$ 
    nasa1515@nasa:~$ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    centos              latest              0d120b6ccaa8        6 days ago          215MB
    ```

----

## 도커 허브를 통한 이미지 업로드, 다운로드 <a name="a3"></a>  

* **도커 이미지 생성**  
먼저 commit_nasa라는 centos 컨테이너를 하나 만들도록 하겠습니다.

    ```
    student@cccr:~$ docker run -itd --name commit_nasa centos:latest
    c4ce10edca0febaddc49c07b31290f542ff2c49751cb16ce0666bc1eac12d6c2
    ```

* **기존에 있는 이미지로 새로운 이미지를 만들기 위해서는 ``docker commit`` 명령어를 사용하면 됩니다.**

    **[배포 테스트를 위한 이미지를 하나 생성하겠습니다.]**
    ```
    nasa1515@nasa:~$ docker commit \
    > -a "nasa1515" \                   # -a: author, 이미지의 작성자
    > -m "commit nasa1515" \            # -m: messages, 커밋 메시지
    > commit_nasa \                     # 복사하고자 하는 이미지
    > nasa1415/centos:nasa1515          # 이미지:[태그], 태그 생략시 'latest'로 붙음
    sha256:7f1b0822d1522842d953acb5bea0e4d1481f68d690fe5fc5d6255e58a976c447
    ------------------------------------------------------------------------------
    nasa1515@nasa:~$ 
    nasa1515@nasa:~$ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    nasa1415/centos     nasa1515            1fec0eefcf65        4 minutes ago       215MB
    centos              latest              0d120b6ccaa8        6 days ago          215MB
    ```
---

* **이미지 배포**  
만들어진 이미지를 배포하기 위해 도커 허브 이미지 저장소를 사용합니다.

    일단 https://hub.docker.com로 들어가서 로그인을 합니다.  
    **[회원가입을 완료 했다면 아래와 같이 저장소가 생성되었을 겁니다]**
    ![스크린샷, 2020-08-17 12-06-53](https://user-images.githubusercontent.com/69498804/90353781-26d3b380-e082-11ea-95ed-7172e61c65fb.png)


* **배포 전 ``docker login`` 명령을 사용해 로그인해줍니다.**  

    ```
    nasa1515@nasa:~$ docker login
    Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
    Username: nasa1415
    Password: 
    WARNING! Your password will be stored unencrypted in /home/student/.docker/config.json.
    Configure a credential helper to remove this warning. See
    https://docs.docker.com/engine/reference/commandline/login/#credentials-store

    Login Succeeded
    ```

* **``docker push`` 명령어를 사용해 업로드 해줍니다.**  

    ```
    $ docker push [이미지 이름]
    
    
    nasa1515@nasa:~$ docker push nasa1415/centos:nasa1515
    The push refers to repository [docker.io/nasa1415/centos]
    291f6e44771a: Pushed 
    nasa1515: digest: sha256:77e7c29b5f9a493a64b981ab17d6d8b0efe5352da325f7f8f78f9101b1d5439b size: 529
    
    ```
    
* **만약 github에 생성한 저장소 이름과 이미지의 태그가 다르면 업로드가 불가합니다.**

    ```
    student@cccr:~$ docker push nasa1515/centos
    The push refers to repository [docker.io/nasa1515/centos]
    291f6e44771a: Preparing 
    denied: requested access to the resource is denied
    ```

* **``push`` 이후 정상적으로 gibhub 저장소에 올라갔음을 확인 할 수 있습니다.**

    ![스크린샷, 2020-08-17 12-27-51](https://user-images.githubusercontent.com/69498804/90354728-153fdb00-e085-11ea-8bee-7b5aa925e77c.png)

----

* **이미지 다운로드**  

* **올려놓은 이미지를 확인하기 위해 기존 host의 이미지를 전부 삭제**  

    ```
    nasa1515@nasa:~$ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    ```

* **``docker pull`` 명령어를 이용해 저장소의 이미지를 다운로드**

    ```
    nasa1515@nasa:~$ docker pull nasa1415/centos:nasa1515
    nasa1515: Pulling from nasa1415/centos
    3c72a8ed6814: Pull complete 
    Digest: sha256:77e7c29b5f9a493a64b981ab17d6d8b0efe5352da325f7f8f78f9101b1d5439b
    Status: Downloaded newer image for nasa1415/centos:nasa1515
    docker.io/nasa1415/centos:nasa1515
    nasa1515@nasa:~$ 
    nasa1515@nasa:~$ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    nasa1415/centos     nasa1515            1fec0eefcf65        About an hour ago   215MB
    ```

------