---
layout: post
title: "[DATA] - AZURE Blob Storage와 Apache Spark와 Hadoop 연결"
author: nasa1515
categories: DATA
date: 2021-03-11 13:36
comments: true
cover: "/assets/1800-550.jpg"
tags: DATA
---



## **AZURE Blob Storage와 Apache Spark와 Hadoop 연결**


<br/>

**머리말**  

**이전 포스트로 드디어 모든 Cluster들을 구성했습니다.**  
**원래 1~2일 정도 예상했는데 아직 모르는 부분들이 많아서**  
**생각보다 시간이 많이 걸렸네요**  
**이제부터라도 python 기반으로 spark data를 다루는 법을 알아봅시다**  



 
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


- [Azure blob Storage 생성](#a1)
- [Zeppelin 설치 후 연동](#a2)

--- 

<br/>

## **Azure blob Storage 생성**   <a name="a1"></a>   