---
layout: post
title: "[DATA] - GCP DataBricks 사용기"
author: nasa1515
categories: DATA
date: 2021-05-06 12:36
comments: true
cover: "/assets/1800-550.jpg"
tags: DATA
---



## **GCP DataBricks 사용기**


<br/>

**머리말**  

**저번 포스트에서 DataProc에 대한 설명과 간단한 사용법을 다뤄봤었습니다.**  
**이번에는 GCP에서 파트너 SaaS형태로 제공해주는 DataBricks를 사용해서** 
**지난번과 동일한 데이터, 스트립트를 이용해서 성능이나, 사용법에 대한 테스트를 해봤습니다.**  
**이번에도 파이썬을 첨가해서**  


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

- [DataBricks?](#a1)
- [GCP DataBricks](#a2)


--- 

## **DataBricks?** <a name="a1"></a> 

![og-databricks](https://user-images.githubusercontent.com/69498804/117228331-cf65b580-ae53-11eb-9b9d-81bd0a524677.png)

**Databricks란?**  
**간단 요약해서 Spark,Hadoop 등 빅데이터 관련 솔루션 실행환경을 제공하는 클라우드 서비스입니다.**  
**통합 분석 플랫폼으로, 한 WorkSpace내에서 여러 서비스를 사용해 모든 분석이 가능합니다.**  
**이전에 Spark, Hadoop을 ON-Premise 환경에 설치한 포스트를 확인해보시면 알겠지만**  
**JDK부터 연동해야 하는 부분이 매우 귀찮고 오랜 시간이 걸리게 됩니다.**  
**DataBricks를 사용하면 설치, 설정 부분 없이 바로 사용이 가능하다는 장점이 있습니다.**  

**DataBricks는 아래 작업들을 한 WorkSpace에서 지원합니다.**  

- **reports**
- **dashboards**
- **ETL 작업 실행 (Extract, Transform, Load)**
- **머신러닝, 스트림 작업**
- **아파치 Spark보다 더 optimized.**
- **Databricks 서버와 실시간으로 interaction**

<br/>

---

## **GCP DataBricks?** <a name="a2"></a> 

**GCP, Azure, AWS 등 3사 Public Cloud는 이미 DataBricks를 SaaS, PaaS 형태로 지원하고 있습니다.**  
**GCP의 경우 아직 도입된지 1년이 채 안되서 불안정한 부분도 있고 Korea Region도 지원하지 않습니다.**  
**아직 GA일정도 나오지 않은 상태구요...(AWS,AZURE는 다 있는데...)**   
**그래서 이번 포스트에서는 어쩔 수 없이 US Region에서의 테스트를 진행하겠습니다.**  


<br/>

* #### **DataBricks 사용하기(구독)**

    **GCP에서 DataBricks를 사용하기 위해서는 다음과 같이 구독을 먼저 진행해야 합니다.**  

    ![da](https://user-images.githubusercontent.com/69498804/117228743-a0037880-ae54-11eb-9362-11dd61314007.JPG)

    * **구독 이후에 DataBricks의 구매 스펙을 정하고 DataBricks Dashborad로 이동하면 됩니다.**  


    <br/>

* #### **WorkSpace 생성**  

    **Dashborad에서 아래와 같이 사용 할 WorkSpace를 생성하면 됩니다.**


    ![캡처2](https://user-images.githubusercontent.com/69498804/117228897-025c7900-ae55-11eb-941b-597f74ec3f45.JPG)


    <br/>

* #### **WorkSpace 접속**  


    **WorkSpace를 생성 후 URL에 접속하면 드디어 데이터 작업을 할 수 있습니다.**  

    ![123123123](https://user-images.githubusercontent.com/69498804/117229354-d42b6900-ae55-11eb-839c-bc1f7979ed4b.JPG)

<br/>


* #### **DataBricks Cluster 생성**  

    **WorkSpace의 Cluster Tab에서 Create Cluster를 클릭해 생성합니다.**  

    ![33333333333333](https://user-images.githubusercontent.com/69498804/117230334-d68ec280-ae57-11eb-939d-295ed700acea.JPG)


<br>

* #### **저는 다음과 같은 Spec으로 Cluster를 생성했습니다.**  

    ![2222](https://user-images.githubusercontent.com/69498804/117380571-f20bd300-af14-11eb-9cae-69720f7c2043.JPG)
    
    * **Nmae : Cluster01** 
    * **Runtime Version : 8.1**  
    * **Worker Type : n2-standard-8** 
    * **Advanced Option Tab을 열어 Google Service Account 입력** 
        **주의 : Service Account는 GCS에 권한이 있어야 합니다.**

<br/>

* **이제 Notebook을 생성하고 GCS를 DBFS에 Mount해서 사용하시면 됩니다.**  


    ```
    bucket_name = "nasagcp"
    mount_name = "gcpdata"
    dbutils.fs.mount("gs://%s" % bucket_name, "/mnt/%s" % mount_name)
    ```
    * **다음과 같은 형식으로 사용하시면 됩니다.**

<br/>

* **저는 이전에 짜놨었던 스크립트를 다음과 같은 형식으로 사용했습니다.** 

    ```
    bucket_name = "nasagcp"
    mount_name = "gcpdat11"
    dbutils.fs.mount("gs://%s" % bucket_name, "/mnt/%s" % mount_name)


    from pyspark.context import SparkContext
    from pyspark.sql.session import SparkSession


    # ------------------------------------------------------------------
    def renameCols(df1, old_columns, new_columns):
        for old_col,new_col in zip(old_columns,new_columns):
            d1f = df1.withColumnRenamed(old_col,new_col)
        return df1


    # Old_columns
    old_columns = ['avg(min_temperature_air_2m_f)',
                    'avg(max_temperature_air_2m_f)',
                    'avg(avg_temperature_air_2m_f)'
                    ]

    # New_columns
    new_columns = ['temperature_air_min_avg',
                    'temperature_air_max_avg',
                    'temperature_air_avg_avg'
                    ]
    # --------------------------------------------
    # ----------------------

    # Read CSV from GCS
    df_lee = spark.read.csv("/mnt/gcpdat11/", header=True, inferSchema=True)

    # data transform
    df_lee = df_lee.groupBy('country', 'date').agg({'min_temperature_air_2m_f' : 'avg', 'max_temperature_air_2m_f' : 'avg', 'avg_temperature_air_2m_f' : 'avg'}).sort(desc('country')).orderBy('date')

    df_result = renameCols(df_lee, old_columns, new_columns)

    country1 = df_result.select("country")
    country_dis10 = df_result.select("country").distinct()
    print("country_count =",country_dis10.count())


    # Write CSV to GCS
    df_result.coalesce(1).write.option("header", "true").mode("overwrite").csv("/mnt/gcpdat11/dbfsre/")
    ```

    * **이전에 받아놨던 Covid-19 기상 데이터를 정렬하는 Code 입니다.**  

<br/> 



## **끝!**



---

## **마치며…**  

  
**사실 DataBricks는 사용법에 대한 가이드를 남기기에는 너무 간편합니다..**  
**그래서 그나마 어려움이 있을 것 같은 DBFS Mount 부분만 설명했습니다.**  

