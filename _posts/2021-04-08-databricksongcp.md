---
layout: post
title: "[DATA] - DataBricks on GCP 환경 구성"
author: nasa1515
categories: DATA
date: 2021-04-07 12:36
comments: true
cover: "/assets/1800-550.jpg"
tags: DATA
---



## **DataBricks on GCP 환경 구성**


<br/>

**머리말**  

**이번 포스트에서는 GCP에서 DataBricks를 운영하는 방법을 다뤄보겠습니다.**  
**이번 포스트 또한 파이썬을 첨가해서**  


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


- [DataBricks on GCP 환경 구성](#a1)
- [Fluentd 설치](#a2)


--- 

## **DataBricks on GCP 환경 구성**    <a name="a1"></a> 

#### **DataBricks on GCP 환경을 구성하는 것부터 진행하도록 하겠습니다.** 

<br/>

* #### **Project 생성 [DataBricks 용]**  

    ![2222](https://user-images.githubusercontent.com/69498804/113955110-18771980-9856-11eb-83f8-856fd602d5c6.JPG)


    * #### **저는 "Databricks"라는 이름으로 새로운 프로젝트를 생성했습니다.**  

    <br/>


* #### **이제 프로젝트에서 사용 할 API를 추가해줍니다.**  

    ![캡처](https://user-images.githubusercontent.com/69498804/113955261-57a56a80-9856-11eb-99cb-6e80ceb8186f.JPG)


    **설치 API 목록**

    * **Cloud Storage API**
    * **Kubernetes Engine API**
    * **Cloud Deployment Manager V2 API**



    <br/>


* #### **이후 새로운 Service Account를 생성합니다.**

    ![캡처3](https://user-images.githubusercontent.com/69498804/113811448-30439480-97a7-11eb-9a42-4e8425375130.JPG)

    * **권한 : 소유자**  
    * **KeyFile : Json**  

    <br/>

* #### **이제 Cloud Storage를 생성합니다.** 

    ![캡처4](https://user-images.githubusercontent.com/69498804/113811803-d68f9a00-97a7-11eb-8cc0-0d6463f8a42b.JPG)


    * **Storage Class : Standard**
    * **Single Region** 

    <br/>


* #### **GCP에서 DataBricks에 대한 구독을 활성화 합니다.** 

    ![캡처2](https://user-images.githubusercontent.com/69498804/113956249-27f76200-9858-11eb-95d5-00eb5285cff9.JPG)


    <br/>

* #### **그럼 다음과 같이 DataBricks의 DashBorad에 접속이 가능합니다.**  

    ![캡처3](https://user-images.githubusercontent.com/69498804/113956373-52491f80-9858-11eb-96b2-0b57d3b350da.JPG)

    <br/>

---

## **DataBricks에서 GCP Project에 WorkSpace를 만들어보죠.**  


* #### **다음과 같이 WorkSpace를 생성해줍니다.**

    ![캡처4](https://user-images.githubusercontent.com/69498804/113956467-76a4fc00-9858-11eb-83f4-c6af09182773.JPG)

    * **Region의 경우 US,EU 두가지만 지원합니다..ㅠㅠ**  


    <br/>

* #### **GCP의 API를 제대로 설정하셨으면 다음과 같이 WorkSpace가 생성됩니다.** 

    ![캡처5](https://user-images.githubusercontent.com/69498804/113956583-a05e2300-9858-11eb-974a-5a5d9da13cf6.JPG)
