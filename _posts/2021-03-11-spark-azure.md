---
layout: post
title: "[DATA] - AZURE Blob Storage와 Apache Hadoop 연결"
author: nasa1515
categories: DATA
date: 2021-03-11 13:36
comments: true
cover: "/assets/1800-550.jpg"
tags: DATA
---



## **AZURE Blob Storage와 Apache Hadoop 연결**


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

**기본적으로 Azure에서 Storage는 Storage Account로 관리됩니다.**  
**때문에 우선적으로 Storage Account를 생성하고 blob container를 생성해야 합니다.**  
**추가적으로 blob을 생성할 때 Data Lake Storage로 생성하셔야 합니다. 이유는 Azure의 Guide를 보면**   

* **[Azure의 blob from Data Lake Storage](https://docs.microsoft.com/ko-kr/azure/storage/blobs/data-lake-storage-introduction)**  
***Hadoop 호환 액세스 지원 : Data Lake Storage Gen2를 사용하면  
HDFS(Hadoop 분산 파일 시스템)에서와 마찬가지로 데이터를 관리하고 액세스할 수 있습니다.  
데이터에 액세스하는 데 사용되는 새로운 ABFS 드라이버는 모든 Apache Hadoop 환경 내에서 사용할 수 있습니다.  
 이러한 환경에는 Azure HDInsight , Azure Databricks 및 Azure Synapse Analytics가 포함됩니다.***

* **Storage Account 및 blob의 생성은 [해당포스트](https://nasa1515.github.io/azure/2021/02/08/AZURE-Storageservice.html#a2)를 확인하시면 됩니다.**


* **일반 blob이 아닌 Data Lake Storage Gen2를 사용하려면 아래 설정만 추가하면 됩니다.**

    ![12312312321](https://user-images.githubusercontent.com/69498804/110719567-66493380-8250-11eb-91fb-544039709c2f.png)

<br/>

* #### **저는 gen2blob을 생성해 TESTDATA.csv 파일을 blob에 upload 했습니다.**

    ![1111111](https://user-images.githubusercontent.com/69498804/110719632-8678f280-8250-11eb-993f-41a1d2c57793.JPG)



# 여기서 잠시 멈춥니다.!