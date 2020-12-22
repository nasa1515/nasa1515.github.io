---
layout: post
title: "[DOCKER] - 네트워크 (NETWORK)"
author: Lee Wonseok
categories: DOCKER
date: 2020-08-14 09:36
comments: true
tags: [DOCKER]
cover: https://res.cloudinary.com/yangeok/image/upload/v1593160497/logo/posts/iot-protocol.jpg
---



# [DOCKER] - 네트워크

**머리말**  
 이전 포스트에서는 도커에서 생성되는 컨테이너들에서 사용하는 볼륨에 대해서 포스트했었다.  
 이번 포스트에서는 컨테이너들의 서비스와 중요하게 연관되어있는  
 도커의 네트워크에 대해서 포스트 했다.  


---


**목차**
- [DOCKER 네트워크?](#a1)
- [BRIDGE NETWORK](#a2)
- [HOST NETWORK](#a3)
- [NULL(NONE) NETWORK](#a4)
- [CONTAINER - CONTAINER](#a5)

---
## [DOCKER] - 네트워크 유형 <a name="a1"></a>

* **도커에는 다양한 네트워크가 존재해 용도에 맞게 네트워크를 선택 할 수 있다.**   

    기본으로 사용하는 네트워크는 `bridge`,`host`,`null`이 존재한다.  
    `docker network ls` 명령어로 네트워크 목록을 확인 할 수 있다.

      $ docker network ls
      -----------------------------------------------------------------
      NETWORK ID          NAME                DRIVER              SCOPE
      e2d1889f7327        bridge              bridge              local
      29d9e0411d39        host                host                local
      054fbf919b85        none                null                local

      -----------------------------------------------------------------
      $ ifconfig docker0
      
      docker0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
      inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
      inet6 fe80::42:2dff:fe83:d3b5  prefixlen 64  scopeid 0x20<link>
      ether 02:42:2d:83:d3:b5  txqueuelen 0  (Ethernet)
      RX packets 14503  bytes 798314 (798.3 KB)
      RX errors 0  dropped 0  overruns 0  frame 0
      TX packets 17644  bytes 118869139 (118.8 MB)
      TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

---

## BRIDGE NETWORK <a name="a2"></a>

* Bridge는 컨테이너가 사용하는 프라이빗 네트워크이다.  
같은 Bridge로 연결되어 있으면 컨테이너의 IP 주소로 통신할 수 있다.  
외부로 통신 할 때에는 `NAPT` 통신을 사용하며  
외부에서 Bridge로 통신을 위해선 `포트포워딩`을 사용해야 한다.  

    도커를 설치하면 이름이 `docker0` 인 리눅스 브릿지가 생성된다.  
    이를 확인 하기 위해선 `inspect` 명령을 이용해 다음과 같이 확인가능하다. 


        $ docker inspect bridge 
        --------------------------------------------------------------
        ...
        ...
                "Options": {
                ...
                ...
                "com.docker.network.bridge.default_bridge": "true",
                "com.docker.network.bridge.enable_icc": "true",
                "com.docker.network.bridge.enable_ip_masquerade": "true",
                "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
                "com.docker.network.bridge.name": "docker0",
                "com.docker.network.driver.mtu": "1500"
        ...
        ...
        ...

        # inspect 내용에 docker0 브릿지를 사용한다는 내용을 확인 가능하다.

---

* **DOCKER BRIDGE NETWORK**  

    docker0 브리지는 컨테이너가 통신하기 위해 사용된다.  
    컨테이너를 생성하면 자동으로 브리지를 활용하도록 설정되어  
    docker0 인터페이스는 `172.17.0.0/16` 서브넷을 갖기 때문에  
    컨테이너가 생성되면 대역 안에서 IP를 할당받게 된다.  
    (예: `172.17.0.2`, `172.17.0.3`)

    `$ docker network inspect bridge` 명령어를 이용하면  
    BRIDGE 네트워크의 자세한 정보를 알 수 있다.

        [
        {
            "Name": "bridge",
            // 중간 생략
            "Driver": "bridge",
            "IPAM": {
                "Driver": "default",
                "Options": null,
                "Config": [
                    {
                        "Subnet": "172.17.0.0/16"
                    }
                ]
            },
            // 중간 생략
            "ConfigOnly": false,
            "Containers": {
                "14b9779c990fe7557d60f2605ff4224e5f85f26bd99807c71f78df45133314be": {
                    "Name": "busybox1",
                    "EndpointID": "3ea17b0de094890abb1cccdb15b9144035d64bdc07777b97ddf9427b27563f51",
                    "MacAddress": "02:42:ac:11:00:02",
                    "IPv4Address": "172.17.0.2/16",
                    "IPv6Address": ""
                }
            }
            // 이하 생략
        }
      ]

---

* **컨테이너를 생성하면? (그림참조)**  

    컨테이너는 Linux Namespace 기술로 격리된 네트워크 공간을 할당받게 된다.  
    즉 언급한 대로 172.17.0.0/16 대역의 IP를 순차적으로 할당 받는다.  
    `이 IP는 컨테이너가 재시작할 때마다 변경될 수 있다.`

    컨테이너는 외부 통신을 위한 2개의 네트워크 인터페이스를 함께 생성한다.  
    하나는 컨테이너 내부 `Namespace`에 할당되는 `eth0` 이름의 인터페이스  
    하나는 호스트 네트워크 브리지 `docker0`에 바인딩 되는 `vethXXXXXXX`  
    이름 형식의 `veth` 인터페이스다. (“veth”는 “virtual eth”라는 의미)  
    컨테이너의 `eth0` 인터페이스와 호스트의 `veth` 인터페이스는 서로 연결되어 있다.

    결국 `docker0 브리지`는 가상 인터페이스와 호스트의 인터페이스를  
    이어주는 `중간 다리 역할`을 한다.  
    그리고 컨테이너의 `eth0` 인터페이스는  
    `veth` 가상 인터페이스를 통해 외부와 통신할 수 있게 되는 것이다.

    ![](https://jonnung.dev/images/docker_network.png)  
    


* **BRIDGE 는 `docker network create` 명령을 사용해 여러 개 생성할 수 있다.**

      $ docker network create --subnet 172.18.0.0/16 --gateway 172.18.0.1 nasanet
      ---------------------------------------------------------------------------
      ddad85781d7f86533869b5d91beb7439194601d05dee28f23d4e2e45719cead6 - 결과 값


* **생성한 네트워크로 `--network` 사용해 컨테이너를 연결 할 수 있다.**

      $ docker run -itd --name nasa --network nasanet centos:latest 
      58f360a0ca8bc409ce9a5ab4f891bf2d7df8821cda533b48cf713f1bfbd23401
      ---------------------------------------------------------------------------
      $ docker inspect nasa | grep -i ipaddress
                  "SecondaryIPAddresses": null,
                  "IPAddress": "",
                          "IPAddress": "172.18.0.2", ---- 해당 네트웍을 사용중

----

## HOST NETWORK <a name="a3"></a>

* HOST NETWORK란 컨테이너의 네트워크 격리를 해제하여  
호스트 네트워크의 정보를 `공유`해서 사용하는 방법이다.  
컨테이너는 호스트 입장에서 하나의 프로세스이기 때문에 가상머신과 다르게  
네트워크 정보를 공유할 수 있다.  
컨테이너가 이 네트워크를 사용할 때 컨테이너의 포트가 호스트에서 사용하는 포트와  
충돌하면 문제가 생기게 된다. `(네트워크 외 다른 환경은 기존과 동일하다)`



* **HOST NETWORK는 `--network host` 명령을 사용해 생성할 수 있다.**

      docker run -idt --name hostos --network host centos:latest 
      88bf0bb7ab73c651bb2a0c9fc9ee553b973e9e7dfac8e8f7127ef9a0ac8c7d24
    
      docker inspect hostos | grep -i NetworkMode
                "NetworkMode": "host",

      docker inspect hostos | grep -i ipaddress
                "SecondaryIPAddresses": null,
                "IPAddress": "",
                        "IPAddress": "",

* **컨테이너 IP와 Interface를 확인해보면 HOST와 동일하다.**

      $ docker exec hostos ip addr show
      --------------------------------------------------------------------------
        1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
            link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
            inet 127.0.0.1/8 scope host lo
            valid_lft forever preferred_lft forever
            inet6 ::1/128 scope host 
            valid_lft forever preferred_lft forever
        2: eno1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
            link/ether b0:5c:da:ad:d1:25 brd ff:ff:ff:ff:ff:ff
        3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
            link/ether d8:12:65:cf:77:53 brd ff:ff:ff:ff:ff:ff
            inet 192.168.100.9/24 brd 192.168.100.255 scope global dynamic noprefixroute wlp3s0
            valid_lft 5755sec preferred_lft 5755sec
            inet6 fe80::c52a:605:275a:a9f4/64 scope link noprefixroute 
            valid_lft forever preferred_lft forever
        4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
            link/ether 02:42:2d:83:d3:b5 brd ff:ff:ff:ff:ff:ff
            inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
            valid_lft forever preferred_lft forever
            inet6 fe80::42:2dff:fe83:d3b5/64 scope link 
            valid_lft forever preferred_lft forever

* **HOST를 사용하기에 DOCKER0에 바인딩 되어있지 않다.**

      $ brctl show
      ----------------------------------------------------------------------
        bridge name	bridge id		STP enabled	interfaces
        br-ddad85781d7f		8000.024257497375	no		veth476053c
        docker0		8000.02422d83d3b5	no		veth26ee67a
                                    veth66ac69f
                                    veth7ab4f7a


* **INSPECT 명령어로 확인해보면 다음과 같다**

    ```
    nasa1515@nasa:~$ docker network inspect host
    [
        {
            "Name": "host",
            "Id": "29d9e0411d39d339a44fb9c8567926771c0e095f5ea51f41d0064c67b863fb0c",
            "Created": "2020-08-10T17:54:41.031173097+09:00",
            "Scope": "local",
            "Driver": "host",
            "EnableIPv6": false,
            "IPAM": {
                "Driver": "default",
                "Options": null,
                "Config": []
            },
            "Internal": false,
            "Attachable": false,
            "Ingress": false,
            "ConfigFrom": {
                "Network": ""
            },
            "ConfigOnly": false,
            "Containers": {
                "b5663b01cf570dd3960cee1471547d0feb6c3b6681a9afa6bdaf68f5fdb9f510": {
                    "Name": "host",
                    "EndpointID": "1cb2f03508e9eab23c7510d10c31c4b763a7abe84d6b4d33630c55d52b620e45",
                    "MacAddress": "",
                    "IPv4Address": "",
                    "IPv6Address": ""
                }
            },
            "Options": {},
            "Labels": {}
        }
    ]
    ```

    Containers 에 임시로 생성한 ``HOST`` 정보가 있지만  
    네트워크 환경을 따로 가지고 있지 않기 때문에 IP 정보는 없다. 


---

## 4. NULL(NONE) NETWORK <a name="a4"></a>

* **``--net=none 옵션``으로 컨테이너를 생성하면 격리된 네트워크 영역을 갖는다  
하지만 인터페이스가 없는 상태로 컨테이너를 생성하게 된다.**


*   **``net=none`` 으로 지정하여 컨테이너를 생성해보겠다.**

    ```
    nasa1515@nasa:~$ docker run -itd --name none-nasa --net=none centos:latest
    6625654470dde0311bd730d1e8a784908995c3d1e8cc7e2b5bf052ffdf24550f
    ```

* **``exec`` 명령을 사용해 네트워크를 확인 결과**
    ```
    nasa1515@nasa:~$ docker exec none-nasa ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
    ```

    위처럼 loopback 인터페이스만 있고, 통신을 위한 eth0 인터페이스는 없다.  
    당연히 bridge에도 연결되지 않은 상태이며, 이 상태로는 외부 통신이 불가하다. 


    이 옵션을 만든 이유는, 아마도 인터페이스를 직접 커스터마이징 할 수 있도록  
    네트워크 환경이 clear 한 상태로 만들기 위해서 인 것으로 예상이된다. 

----

## 5. CONTAINER - CONTAINER <a name="a5"></a>

* **이 방식으로 생성된 컨테이너는 기존에 존재하는 다른 컨테이너의 network 환경을 공유한다.** 


    이해를 쉽게하기 위해 아래 실습을 진행해보았다. 



* **먼저 ``nasa-master`` 라는 이름으로 컨테이너를 생성 했다** 

    ```
    nasa1515@nasa:~$ docker run -idt --name nasa-master centos:latest
    f91ea38db58198c540916d9e697931a77af312a3e6e7f63f6e9f031e33701ba9
    ```

*  **이제 ``nasa-slave`` 컨테이너를 생성할때 ``nasa-master``의 network 환경을 공유하게 만들어 보자.** 

    ```
    옵션 : --net=container:CONTAINER_ID
    ```

    ```
    nasa1515@nasa:~$ docker run -itd --name nasa-slave --net=container:f91ea38db58198 centos:latest
    e904d45bc36ac6ad16925cc2cef9fbb80e0ac0f858dec129828463ab570a2476
    ------------------------------------------------------------------------------------
    nasa1515@nasa:~$ docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
    e904d45bc36a        centos:latest       "/bin/bash"         About a minute ago   Up About a minute                       nasa-slave
    f91ea38db581        centos:latest       "/bin/bash"         8 minutes ago        Up 8 minutes                            nasa-master

    ```
    위와 같이 ``nasa-master`` 컨테이너와 ``nasa-slave`` 컨테이너가 생성되었다.


* **하지만 ``nasa-slave`` 컨테이너는 따로 IP를 갖지 않으며 ``master``와 같은 IP와 MAC 주소를 확인 할 수 있다.**

    ```
    nasa1515@nasa:~$ docker exec nasa-master ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
    39: eth0@if40: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
        link/ether 02:42:ac:11:00:07 brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet 172.17.0.7/16 brd 172.17.255.255 scope global eth0
        valid_lft forever preferred_lft forever
    
    ---------------------------------------------------------------------------------

    nasa1515@nasa:~$ docker exec nasa-slave ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
    39: eth0@if40: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
        link/ether 02:42:ac:11:00:07 brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet 172.17.0.7/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
    ```

* **``bridge insptec``를 봐도 ``slave`` 서버의 정보는 확인 할 수 없다.**

    ```
    [
        {
            "Name": "bridge",
            "Id": "c4031fa4ad4b778e12280591052b52b82d97fdaf64bb0e3e45343f5501aa39aa",
            "Created": "2020-08-14T14:31:29.774610308+09:00",
            "Scope": "local",
            "Driver": "bridge",
            "EnableIPv6": false,
            "IPAM": {
                "Driver": "default",
                "Options": null,
                "Config": [
                    {
                        "Subnet": "172.17.0.0/16",
                        "Gateway": "172.17.0.1"
                    }
                ]
            },
            "Internal": false,
            "Attachable": false,
            "Ingress": false,
            "ConfigFrom": {
                "Network": ""
            },
            "ConfigOnly": false,
            "Containers": {
                "f91ea38db58198c540916d9e697931a77af312a3e6e7f63f6e9f031e33701ba9": {
                    "Name": "nasa-master",
                    "EndpointID": "77c63905bc98fe21a3b80ddc676ac4d495e79f66e96b75f2c6f5ab0ae4ccfdfc",
                    "MacAddress": "02:42:ac:11:00:07",
                    "IPv4Address": "172.17.0.7/16",
                    "IPv6Address": ""
                }
            },
            "Options": {
                "com.docker.network.bridge.default_bridge": "true",
                "com.docker.network.bridge.enable_icc": "true",
                "com.docker.network.bridge.enable_ip_masquerade": "true",
                "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
                "com.docker.network.bridge.name": "docker0",
                "com.docker.network.driver.mtu": "1500"
            },
            "Labels": {}
        }
    ]
    ```
-----

