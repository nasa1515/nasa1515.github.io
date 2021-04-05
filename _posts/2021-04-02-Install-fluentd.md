---
layout: post
title: "[DATA] - Fluentd Install with Azure VM"
author: nasa1515
categories: DATA
date: 2021-04-02 12:36
comments: true
cover: "/assets/1800-550.jpg"
tags: DATA
---



## **Fluentd Install with Azure VM**


<br/>

**머리말**  

**이전 포스트를 다 마무리 짓지 못하고 이번 포스트로 이적했습니다..**  
**kubernetes 환경에서 먼저 환경을 구성해보려고 했으나 이미징부터 여러 문제가 있어서**  
**그 부분에서 시간을 잡아먹히는 것 보단 기능 테스트부터 하려는 목적입니다..**  

 
---

**DATA 시리즈**




**이론**



 - [Apache Spark](https://nasa1515.github.io/data/2021/03/03/spark.html)


**실습** 

 - [Azure Synapse Analytics](https://nasa1515.github.io/data/2021/02/25/azure-synapse.html)
 - [Azure VM에 Apache Spark v3.0 Standalone 설치 With Zeppelin](https://nasa1515.github.io/data/2021/03/04/Spark2.html)
 - [Hadoop 3.3.0 Full Distribute mode infra 구축](https://nasa1515.github.io/data/2021/03/08/hadoop.html)
 - [Apache Spark v3.0 on yarn 설치 With Zeppelin](https://nasa1515.github.io/data/2021/03/10/spark-yarn.html)

---

**목차**


- [설치 환경](#a1)
- [Fluentd 설치](#a2)


--- 

## **설치 환경**    <a name="a1"></a> 

**Azure Virtual Machine을 2대 사용하여 한대씩 Agent, Aggregator로 구성합니다.**  

* **Agent Server (DS3 v2,4 vcpus, 14 GiB memory) - Centos 8.2**
* **Aggregator Server (Standard D2s_v4,2 vcpus, 8 GiB memory) - Centos  8.2**


    <br/>


## **Fluentd 설치** <a name="a2"></a> 

<img width="446" alt="다운로드" src="https://user-images.githubusercontent.com/69498804/113373226-5a5f1600-93a5-11eb-87da-5aa85207d8b5.png">


* **[공식 사이트](https://www.fluentd.org)**

    <br/>

**저는 `td-agent v3`라는 특정 agent를 사용해서 input/ouput을 쉽게 관리해보겠습니다.**  

<br/>

#### **NTP (시간동기화 설정)**  

* **NTP 삭제 (Centos 7 이후로는 chrony를 사용합니다.)**

    ```
    # sudo yum erase 'ntp*'
    ```

    <br/>

* **chrony 설치** 

    ```
    # sudo yum install -y chrony
    ```

    <br/>

* **/etc/chrony.conf 파일에 설정 적용**

    ```
    server time.bora.net iburst
    ```

    <br/>

* **chrony daemon 시작**

    ```
    # sudo systemctl start chronyd
    ```

    <br/>

* **Time-zone 설정** 

    ```
    # sudo timedatectl set-timezone Asia/Seoul
    ```

    <br/>

* **시간 및 Time-zone 확인**  

    ```
    [root@agent ~]# date
    Fri Apr  2 13:57:56 KST 2021
    [root@agent ~]# 
    [root@agent ~]# timedatectl
                Local time: Fri 2021-04-02 13:58:03 KST
            Universal time: Fri 2021-04-02 04:58:03 UTC
                  RTC time: Fri 2021-04-02 04:58:03
                 Time zone: Asia/Seoul (KST, +0900)
    System clock synchronized: yes
               NTP service: active
           RTC in local TZ: no 
    ```   

    <br/>

#### **Network Kernel Parameters 설정**  

* **/etc/sysctl.conf의 설정 변경**  

    ```
    net.core.somaxconn = 1024
    net.core.netdev_max_backlog = 5000
    net.core.rmem_max = 16777216
    net.core.wmem_max = 16777216
    net.ipv4.tcp_wmem = 4096 12582912 16777216
    net.ipv4.tcp_rmem = 4096 12582912 16777216
    net.ipv4.tcp_max_syn_backlog = 8096
    net.ipv4.tcp_slow_start_after_idle = 0
    net.ipv4.tcp_tw_reuse = 1
    net.ipv4.ip_local_port_range = 10240 65535
    ```

    <br/>

* **설정 적용**  

    ```
    # sysctl -p
    ```

    <br/>

#### **Fluentd 설치 with RPM pakage td-agent** 

* **td-agent 설치**

    ```
    # curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh
    ```

    <br/>

* **td-agent 실행** 

    ```
    # systemctl start td-agent.service 
    ```

    <br/>

* **HTTP Log 수신 Test** 

    ```
    # curl -X POST -d 'json={"message":"Hello IM NASA1515"}' http://localhost:8888/debug.test
    #
    # tail -n 1 /var/log/td-agent/td-agent.log

    ### 결과

    [root@agent td-agent]# curl -X POST -d 'json={"message":"Hello IM NASA1515"}' http://localhost:8888/debug.test
    [root@agent td-agent]# tail -n -1 /var/log/td-agent/td-agent.log 
    2021-04-02 14:44:47.835275366 +0900 debug.test: {"message":"Hello IM NASA1515"}
    ```

    <br/>

