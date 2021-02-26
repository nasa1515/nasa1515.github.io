---
layout: post
title: "[DATA] - Azure Synapse Analytics"
author: nasa1515
categories: DATA
date: 2021-02-25 12:36
comments: true
cover: "/assets/1800-550.jpg"
tags: DATA
---



## **Azure Synapse Analytics**


<br/>

**머리말**  

**블로그에도 매번 인프라나 Devops 관련 글들만 올라와서**  
**최근에 공부하고 있는 Data쪽도 포스트를 늘리려고 합니다.**  
**아직 초급자 수준이라서 틀린 내용이 많을 것 같지만, 복습하는 느낌으로...**  
**본 포스트에서 내용들은 모드 MS Doc를 기준으로 정리해 작성했습니다.**


  


 
---

**DATA 시리즈**

* **이론**



---



**목차**


- [Azure Synapse Analytics](#a1)
- [Azure Portal 에서 작업영역 생성](#a2)
- [SQL Pools을 이용한 간단한 쿼리 테스트](#a3)


--- 

<br/>

## **Azure Synapse Analytics**   <a name="a1"></a>  

**Synapse Analytics는 엔터프라이즈 데이터 웨어하우징과 빅 데이터 분석을 결합한 SaaS 입니다.**  
**Synapse의 용어 중의 SQL Pool (SQL DW)은 Synapse Analytics에서 사용할 수 있는  
``엔터프라이즈 데이터 웨어하우징 기능``을 나타냅니다.** 

<br/>

* #### **Enter Prise Data WareHousing**

    ***엔터프라이즈 영역에서 정적 Data (ex. 영업 데이터, 매출 데이터, 개발 데이터 등)을***  
    ***ETL (extract, transform, load), 전처리(가공) 전 중앙에 모아 관리하는 논리 로직***

<br/>

* #### **SQL 전용 풀(Dedicated-leading SQL), (전 SQL DW)**  

    ***Synapse SQL을 사용할 때 프로비저닝되는 분석 리소스의 컬렉션을 표현합니다.***  
    ***(SQL POOL의 크기와 가격은 DWU(Data WareHouse Unit)에 의해 결정됩니다.*** 

<br/>

* #### **Dedicated SQL은 다음과 같은 Synapse Architecture에 포함됩니다.** 

    ![dedicated-sql-pool (1)](https://user-images.githubusercontent.com/69498804/109120531-6abe1880-7789-11eb-8b03-7e3a301f9f3b.png)

    **Synapse analytics에서 사용가능한 서비스 아키텍쳐**  
    **각 서비스의 설명은 차후 포스트로 나눠서 진행 예정입니다.**

    * **Deficated SQL Pools**
    * **Serverless SQL Pool**
    * **Apache Spark Pools**
    * **Pipelines (Data 통합)**
    * **Shared metadata system**
    * **Connected Service**

<br/>

---


## **Azure Portal 에서 Synapse Analystics 영역 생성**   <a name="a2"></a>  

<br/>

* #### **Porter에서 Create resource Tab에서 Azure Synapse analystics 검색 후 설치**

    ![캡처2](https://user-images.githubusercontent.com/69498804/109130587-40725800-7795-11eb-871b-24912db54ae1.JPG)

<br/>


* #### **Basic 옵션 설정**

    ![캡처3](https://user-images.githubusercontent.com/69498804/109235009-29bd1700-7810-11eb-9521-8cfa1ca9db1d.JPG)

    * **RG**
    * **Workspace name**
    * **Region**
    * **Account name**
    * **File System name**

<br/>

---

* #### **생성된 Synapse workspace에 접속합니다.**

    ![캡처4](https://user-images.githubusercontent.com/69498804/109237068-40fe0380-7814-11eb-92c3-17f4af65a87c.JPG)


<br/>

* #### **Work Space Web URL에 접속합니다.**

    ![캡처6](https://user-images.githubusercontent.com/69498804/109237187-6c80ee00-7814-11eb-8783-9ceee0ed2c19.JPG)


<br/>

* #### **다음과 같은 Web URL에 접속됩니다!**

    ![캡처7](https://user-images.githubusercontent.com/69498804/109237303-a651f480-7814-11eb-8432-cd1bdb399f61.JPG)

    **WEB URL에서는 다음과 같은 Blade로 나뉩니다.**
    * **HOME : 홈 화면 UI**
    * **DATA : DB or Linked 되어있는 Lake Storage 등**
    * **Develop : SQL Scirpt, Data flow등 쿼리에 대한 작업**
    * **Integrate : Develop 과정을 통합하는 파이프라인 작업**
    * **Monitor : Develop, Integrate 작업에 대한 모니터링**
    * **Manage : SQL Pools, Spark Pools, 파이프라인 등 관리**

<br/>

---

## **SQL Pools을 이용한 간단한 쿼리 테스트** <a name="a3"></a>  


* #### **TEST를 위한 SQL Pools을 생성해봅시다.**

    ![캡처11](https://user-images.githubusercontent.com/69498804/109242652-d900ea80-781e-11eb-9651-f63c35cc4f96.JPG)

    * **다음과 같은 Manage tab -> SQL Pools -> NEW로 생성가능**   
    * **Built-in으로 Serverless를 주긴하지만 사용하지 않을 겁니다.**

<br/>


* **생성 된 SQL Pools은 Data Tab에서 다음과 같이 확인이 가능합니다.**

    ![캡처22](https://user-images.githubusercontent.com/69498804/109244981-064f9780-7823-11eb-9c00-47998f326b06.JPG)

<br/>

* #### **이 후 간단히 만든 TEST_data를 넣어서 확인해봅시다.**

    ![캡처8](https://user-images.githubusercontent.com/69498804/109240640-309d5700-781b-11eb-973f-2825baafa97a.JPG)

    * **Data Tab -> Lake Storage의 파일시스템에 다음과 같이 UPload 가능**

<br/>

* #### **저는 다음과 같이 미리 생성해둔 test csv 파일을 업로드 했습니다.**

    ![캡처5](https://user-images.githubusercontent.com/69498804/109240823-87a32c00-781b-11eb-85e3-421b3e2c98d8.JPG)

<br/>