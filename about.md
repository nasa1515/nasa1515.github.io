---
layout: page
title: 블로그 주인
permalink: /about/
---


<p align="center">
<img src="https://user-images.githubusercontent.com/69498804/102948258-de814200-4508-11eb-9e72-73c5d583fe15.PNG" width="60%" height="60%" />
</p>

<br>

<center><h2>IM</h2><h3>NASA1515 - Lee Wonseok (이원석)</h3></center>

<center><h4>DevOps 엔지니어를 희망하여 관련 기술을 운영하는 블로그입니다.</h4></center>

<br>

<span class="page-divider">
  <span class="one"></span>
  <span class="two"></span>
</span>


<h2><center>경험</center></h2>



<br/>

  * **2020-12 ~ Cloocus 재직**  
  * **2020-06 ~ 2020-11 CCCR ACADEMY DevSecOps**  
  * **2014-07 ~ 2016-09 KT VOD 인프라 엔지니어**

<br/>

<span class="page-divider">
  <span class="one"></span>
  <span class="two"></span>
</span>

<h2><center>프로젝트</center></h2>



<h3 id="CICD"><center>DevSecOps CI/CD PIPELINE With 조민재 멘토</center></h3>  

<br/>


<p align="center">
<img src="https://user-images.githubusercontent.com/69498804/103046467-b9093c80-45cb-11eb-859e-6a22551ef45d.PNG" width="60%" height="60%" />
</p> 

<br/>

## **DevSecOps CI/CD PIPELINE Project ?**

* 내용 : 3명의 팀원으로 진행한 GCP 기반의 DevSecOps 파이프라인 구축 프로젝트이다.  
  
* 기간 : 2020. 9 ~ 2020. 11
* 목표 : Cloud Native Service를 MAS로 운영하기 위해 인프라 구축, 설계를 진행한다
.
    * Round 1 : GCP의 기본 시스템 인프라 구축
    * Round 2 : Cloud Build VS OpenSource의 파이프라인 안정성 및 범용성 측정
    * Round 3 : k8s 서비스 클러스터 구축 및 설계
    * Round 4 : CI 서버 구축 및 설계 (Jenkins)
    * Round 5 : CD 서버 구축 및 설계 (K8S - ArgoCD)
    * Round 6 : 완성된 파이프라인내에서 보안적 요소 점검
    * Round 7 : 발견된 취약점들을 위한 OpenSource Tool 검사 자동화 (sonarqube, ZAP, Anchore..)


**배운점** 

* Cloud 인프라 구축 능력 향상
* k8s 구축, 설계, 운영 능력 향상
* 다양한 OpenSource Tool 경험
* 보안적인 요소의 중요성

**느낀점**
- 멘토 1명 <-> 멘티 3명으로 약 2달정도 프로젝트를 진행했다.  
정말 뜬 구름으로 생각했던 클라우드를 전반적으로 다뤄 볼 수 있는 좋은 기회였다.  
멘토님은 우리가 여러 갈래의 길을 찾게되면 그 길의 경우의 수를 줄여 줄 뿐  
세세하게 알려주지 않는 것이 자신이 추구하는 바라고 하셨다. (우리의 능력을 향상 시켜주기 위함)  
처음 접했을 때는 정말 막막했었다.  
그러나 1주 2주 지나면서 조금씩이지만 결과물이 나오니  
스스로 방법을 찾게 되고 용기를 얻었다.  
팀원들과 같이 노력한 결과로 코엑스에서 프로젝트에 대한 발표회도 진행했고  
자랑스럽게도 최우수상을 수상했다.

**결과물**  

* **최우수상 탔다!!**

  ![KakaoTalk_20201224_093545708](https://user-images.githubusercontent.com/69498804/103046728-9e839300-45cc-11eb-968c-eb1c834b21bd.jpg)


* **전체적인 진행 프로세스 동영상**

  <iframe width="560" height="315" src="https://www.youtube.com/embed/qNksz-lEgic?start=1" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

  * **전체적인 프로세스 요약**

    **1. 소스코드를 Clone 해온 뒤 Build 테스트**  
    **2. Dependency-Check Analysis 로 코드 정적분석**  
    **3. Sonarqube and Quality gate 정적분석**  
    **4. 위의 검사에서 에러가 없으면 Docker image build**  
    **5. 빌드한 도커이미지를 HARBOR 저장소에 PUSH**  
    **6. HARBOR에 저장된 이미지의 에러 검사**  
    **7. 새로운 빌드 넘버로 메니페스트 수정 후 GITOPS 저장소로 푸시**  
    **8. ArgoCD로 Sync 요청**  
    **9. ArgoCD는 새로 추가된 메니페스트와 이미 배포되어있는 메니페스트를 diff해 재 배포**  
    **10. 서비스 배포가 완료되었으면 OWASP ZAP으로 전체적인 서비스 보안 동적분석**

<br/>

- **인프라 구축부터 툴 설치 과정은 블로그 게시글에 DevOps 카테고리 참고!**