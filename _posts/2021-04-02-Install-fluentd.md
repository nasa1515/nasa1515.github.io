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

---



### **NTP (시간동기화 설정)**  

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

---

### **Network Kernel Parameters 설정**  

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

---

### **Fluentd 설치 with RPM pakage td-agent** 

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

    ### 결과 정상!

    [root@agent td-agent]# curl -X POST -d 'json={"message":"Hello IM NASA1515"}' http://localhost:8888/debug.test
    [root@agent td-agent]# tail -n -1 /var/log/td-agent/td-agent.log 
    2021-04-02 14:44:47.835275366 +0900 debug.test: {"message":"Hello IM NASA1515"}
    ```

    <br/>

---

### **Fluentd 설정**

**저의 경우에는 여러 VM의 특정 로그를 하나의 Aggregator에 수집하고 싶습니다.**  
**그래서 Agent Server는 -> Aggregator로**  
**Aggregator는 받은 정보를 한 파일에 남기도록 구성했습니다.**  


<br/>

* #### **Agent Server의 td-agent.conf**

    ```
    <source>
        @type tail      #읽을때 맨 아래 줄부터 읽는다.
        path /home/nasa1515/send/*          # 읽을 Path
        pos_file /home/nasa1515/send/test_log.pos
        tag nasalog         #Tag 설정
        format json         #File format 설정
        refresh_interval 5s     # 전송주기
    </source> 

    <match nasa*>
        @type forward           # 전달타입
        flush_interval 10s
        <server>                # remote 서버 설정
            name Aggregator
            host {Aggregator ServerIP}
            port 24224
        </server>
    </match>
    ```

    <br/>

* #### **Aggregator Server의 td-agent.conf**

    ```
    # INPUT
    <source>
        @type forward     # forward 프로토콜을 이용하여 전송받는다. (forward는 전송은 tcp로 하고, health check는 udp로 하는 방식)
        port 24224           # 24224 포트를 이용한한다.
    </source>
    
    # Output
    <match nasalog>     # 보내는 부분에서 tag를 지정하여, tag별로 설정 가능하다.
        @type file      # 받은 내용을 파일로 저장함
        path /home/nasa1515/recv/nasa-total.json   # 이 경로에 저장함. (파일명을 명시할 수도 있는 것 같다.)
    </match>
    ```

<br/>

---

### **로그 수집 확인**

**JSON 형식의 로그를 쌓는 간단한 스크립트를 작성해서 로그를 쌓아봤습니다.**  

<br/>


* #### **스크립트**

    ```
    #!/bin/bash 



    for i in `seq 0 1000` ;do 
        NOW=`date "+%Y-%m-%d"T"%H:%M:%S"Z""`
        echo '{"board_id": '$i',"playtime": 5,"minimum_play": "Y","timestamp": "'$NOW'","user_id": '$i',"interest": 100}' >> send/nasa1515.json
        sleep 30
    done
    ```

    <br/>

* #### **Agent 확인**  

    #### **임의의 JSON로그는 다음과 같이 남습니다.**  

    ```
    {"board_id": 197,"playtime": 5,"minimum_play": "Y","timestamp": "2021-04-05T16:06:02Z","user_id": 197,"interest": 100}
    {"board_id": 198,"playtime": 5,"minimum_play": "Y","timestamp": "2021-04-05T16:06:32Z","user_id": 198,"interest": 100}
    {"board_id": 199,"playtime": 5,"minimum_play": "Y","timestamp": "2021-04-05T16:07:02Z","user_id": 199,"interest": 100}
    {"board_id": 200,"playtime": 5,"minimum_play": "Y","timestamp": "2021-04-05T16:07:32Z","user_id": 200,"interest": 100}
    ```

    <br/>

    #### **생성된 해당 파일을 Agentd에서 읽어 들이는 Log**

    ```
    2021-04-05 14:14:44 +0900 [info]: #0 detected rotation of /home/nasa1515/send/nasa1515.json; waiting 5 seconds
    2021-04-05 14:19:42 +0900 [info]: #0 following tail of /home/nasa1515/send/nasa1515.json
    ```

    <br/>


* #### **Aggregator 확인**  


    #### **특정 Buffer를 받게되면 다음과 같이 폴더를 생성합니다.**
    ```
    [root@Aggregator recv]# pwd
    /home/nasa1515/recv
    [root@Aggregator recv]# ls
    nasa-total.json
    [root@Aggregator recv]#     
    ```

    <br/>

    #### **해당 디렉토리에는 전달받은 Data의 buffer.log와 metadata가 존재합니다.**  

    ```
    [root@Aggregator nasa-total.json]# ls -alrt 
    total 40
    drwxr-xr-x. 2 td-agent td-agent   115 Apr  5 14:20 .
    drwxrwxrwx. 3 root     root        29 Apr  5 16:12 ..
    -rw-r--r--. 1 td-agent td-agent    80 Apr  5 16:14 buffer.b5bf32dab39be6dff270bba644af168fd.log.meta
    -rw-r--r--. 1 td-agent td-agent 35123 Apr  5 16:14 buffer.b5bf32dab39be6dff270bba644af168fd.log
    [root@Aggregator nasa-total.json]# 
    [root@Aggregator nasa-total.json]# cat buffer.b5bf32dab39be6dff270bba644af168fd.log.meta 
    �J��timekey�`i�p�tag��variables��seq�id�[�-�9�m�'
                                                    �dJ�h��s��c�`j��m�`j��[root@Aggregator nasa-total.json]# 
    [root@Aggregator nasa-total.json]# 
    [root@Aggregator nasa-total.json]# tail -n 10 buffer.b5bf32dab39be6dff270bba644af168fd.log
    2021-04-05T16:09:32+09:00       nasalog {"board_id":204,"playtime":5,"minimum_play":"Y","timestamp":"2021-04-05T16:09:32Z","user_id":204,"interest":100}
    2021-04-05T16:10:02+09:00       nasalog {"board_id":205,"playtime":5,"minimum_play":"Y","timestamp":"2021-04-05T16:10:02Z","user_id":205,"interest":100}
    2021-04-05T16:10:32+09:00       nasalog {"board_id":206,"playtime":5,"minimum_play":"Y","timestamp":"2021-04-05T16:10:32Z","user_id":206,"interest":100}
    2021-04-05T16:11:02+09:00       nasalog {"board_id":207,"playtime":5,"minimum_play":"Y","timestamp":"2021-04-05T16:11:02Z","user_id":207,"interest":100}
    2021-04-05T16:11:32+09:00       nasalog {"board_id":208,"playtime":5,"minimum_play":"Y","timestamp":"2021-04-05T16:11:32Z","user_id":208,"interest":100}
    2021-04-05T16:12:02+09:00       nasalog {"board_id":209,"playtime":5,"minimum_play":"Y","timestamp":"2021-04-05T16:12:02Z","user_id":209,"interest":100}
    2021-04-05T16:12:32+09:00       nasalog {"board_id":210,"playtime":5,"minimum_play":"Y","timestamp":"2021-04-05T16:12:32Z","user_id":210,"interest":100}
    2021-04-05T16:13:02+09:00       nasalog {"board_id":211,"playtime":5,"minimum_play":"Y","timestamp":"2021-04-05T16:13:02Z","user_id":211,"interest":100}
    2021-04-05T16:13:32+09:00       nasalog {"board_id":212,"playtime":5,"minimum_play":"Y","timestamp":"2021-04-05T16:13:32Z","user_id":212,"interest":100}
    2021-04-05T16:14:02+09:00       nasalog {"board_id":213,"playtime":5,"minimum_play":"Y","timestamp":"2021-04-05T16:14:02Z","user_id":213,"interest":100}
    ```

## **[잠시 대기,]이제 Aggregator에서 수집한 로그를 Azure LakeStorage에 전달하겠습니다.**  
