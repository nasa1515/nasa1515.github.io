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


--- 

<br/>

## **Azure Synapse Analytics**   <a name="a1"></a>  

**Synapse Analytics는 엔터프라이즈 데이터 웨어하우징과 빅 데이터 분석을 결합한 SaaS 입니다.**  
**Synapse의 용어 중의 SQL Pool (SQL DW)은 Synapse Analytics에서 사용할 수 있는  
``엔터프라이즈 데이터 웨어하우징 기능``을 나타냅니다.** 

<br/>

* #### **Enter Prise Data WareHousing**

    ***엔터프라이즈 영역에서 정적 Data (ex. 영업 데이터, 매출 데이터, 개발 데이터 등)을***  
    ***ETL (extract, transform, load), 전처리(가공) 전 중앙에 모아 관리하는 논리 로직****

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


## **Azure Portal 에서 작업영역 생성**   <a name="a2"></a>  

* #### **Porter에서 Create resource Tab에서 Synapse analystics 검색 후 설치**