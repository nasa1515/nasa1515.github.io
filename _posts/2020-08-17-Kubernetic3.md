---
layout: post
title: "[Kubernetes] - 쿠버네티스 명령어 정리"
author: Lee Wonseok
categories: Kubernetes
date: 2020-08-17 11:36
comments: true
cover: "/assets/kubernets.jpg"
tags: Kubernetes
---



#  KUBERNETES - 쿠버네티스 명령어 정리    

**머리말**  
이제 실습전 알아야 할 이론적인 부분들은 모두 포스팅 했다.  
이번 포스트 부터 이후 포스트까지는 실습에 대한 내용들을 다룰 것이다.    


---


**목차**

- [kubectl 명령어](#a1)
- [kubectl 기본 사용법](#a2)
- [치트시트 내용 정리](#a3)

---

## kubectl 명령어  <a name="a1"></a>


**쿠버네티스는 ``kubectl`` 이라는 CLI 명령어를 통해서  
쿠버네티스 및 클러스터 관리, 디버그 및 트러블 슈팅들을 할 수 있습니다.  
자세한 내용을 알고 싶으면 [kubectl 치트 시트](https://kubernetes.io/ko/docs/reference/kubectl/cheatsheet/)를 참고하세요**

* **``kubectl 명령어``는 기본적으로 아래와 같은 형태로 커맨드 라인에 입력하여 사용할 수 있습니다.**

    ```
    $ kubectl [command] [type] [name] [flags]
    ```

    * **``command`` : 자원에 실행하려는 동작**
        * **``create`` : 생성**
        * **``get`` : 정보 가져오기**
        * **``describe`` : 자세한 상태 정보**
        * **``delete`` : 삭제**  

    * **``type`` : 자원 타입**
        * **``pod`` : Pod**
        * **``service`` : 서비스**

    * **``name`` : 자원 이름**

    * **``flag`` : 옵션**

---

### **``사전 작업``**

**아마 처음 kubectl을 사용하게 된다면 아래와 같은 에러 메세지를 띄울 것입니다.**

```
[root@nasa-master ~]# kubectl get pod
The connection to the server 10.146.0.6:6443 was refused - did you specify the right host or port?
```

* **위와 같은 경우는 현재 권한이 없는 경우로 아래의 명령어를 진행하면 작동 가능합니다.**

    ```
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```

    **일반 사용자 권한에 추가**

    ```
    export KUBECONFIG=/etc/kubernetes/admin.conf
    ```
    **root권한에서 환경변수 등록**

* **kubelet 재시작**

    ```     
    [root@nasa-master ~]# systemctl restart kubelet
    [root@nasa-master ~]# 
    ```

* **이제 정상적으로 명령어 사용이 가능합니다!!!**

    ```
    [root@nasa-master ~]# kubectl get node
    NAME          STATUS   ROLES    AGE   VERSION
    nasa-master   Ready    master   23d   v1.15.5
    nasa-node1    Ready    <none>   23d   v1.15.5
    nasa-node2    Ready    <none>   23d   v1.15.5
    nasa-node3    Ready    <none>   23d   v1.15.5
    ```
---

### **``kubectl 기본 사용법``** <a name="a2"></a>

**간단히 에코 서버(=클라이언트가 전송해주는 데이터를 그대로 되돌려 전송하는 서버)를 동작시켜보겠습니다.**

* **먼저 아래 명령어를 통해서 nasaehco라는 pod를 하나 생성하겠습니다.**

    ```
    $ kubectl run nasaecho --generator=run-pod/v1 --image="k8s.gcr.io/echoserver:1.10" --port=8080
    ```

    ```
    [root@nasa-master ~]# kubectl run nasaecho --generator=run-pod/v1 --image="k8s.gcr.io/echoserve
    r:1.10" --port=8080
    pod/nasaecho created
    [root@nasa-master ~]# 
    ```
    **각각의 내용은 이 후 좀 더 자세히 다루겠지만  
    간단히 설명하면 ``run 명령어``는 클러스터에 특정 이미지를 가지고 ``pod를 생성``하는 명령어 입니다.**

    ```
    $ kubectl run [생성할 POD 이름] --generator=[Repolication Controller 지정] --image=[사용할 이미지] --port=[포트정보]
    ```
    **k8s.gcr.io는 구글의 Container Registry에서 가져오겠다는 의미입니다.  
    –generator : Replication Controller를 지정합니다.**

---

<br/>

* **아래 명령어를 입력하면 pod 들의 정보를 볼 수 있습니다.**

    ```
    $ kubectl get pods
    ```


    ```
    [root@nasa-master ~]# kubectl get pod
    NAME       READY   STATUS    RESTARTS   AGE
    nasaecho   1/1     Running   0          4m12s
    [root@nasa-master ~]# 
    ```
    **각각의 의미는**

    * **``NAME`` : Pod 이름**
    * **``READY`` : 0/1(생성되었지만 사용 준비 X) / 1/1(생성되었지만 사용 준비 O)**
    * **``STATUS`` : Running (실행) / Terminating / ContainerCreating**
    * **``RESTARTS`` : 재시작 횟수**
    * **``AGE`` : 생성 후 지난 시간**

<br/>

* **이제 명령어를 통해서 만들어진 nasaecho pod의 ``서비스``를 생성하도록 하겠습니다.**

    ```
    $ kubectl expose pod nasaecho --type=NodePort
    ```

    ```
    [root@nasa-master ~]# kubectl expose pod nasaecho --type=NodePort
    service/nasaecho exposed
    ```


* **아래 명령어로 현재 만들어진 서비스 정보들을 확인할 수 있습니다.**

    ```
    $ kubectl get services
    ```

    ```
    [root@nasa-master ~]# kubectl get service
    NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
    kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP          23d
    nasaecho     NodePort    10.109.171.229   <none>        8080:30880/TCP   5m3s
    ```


    **각각의 의미는**

    * **``NAME`` : 서비스 이름**
    * **``TYPE`` : 서비스 타입**
    * **``Cluster IP`` : 서비스에 클러스터 IP (내부 IP)를 할당합니다.**
    * **``Load Balancer`` : 외부 IP를 가진 로드밸런서를 할당합니다.**
    * **``Node Port`` : 클러스터 IP 뿐만 아니라 노드의 IP 및 포트를 통해서 접근을 할 수 있습니다.**
    * **``External Name`` : 외부 서비스를 쿠버네티스 내부에서 호출하고자 할 때 사용할 수 있습니다.**
    * **``CLUSTER-IP`` : 클러스터 안에서 사용하는 IP**
    * **``EXTERNAL-IP`` : 외부 IP**
    * **``PORT(S)`` : 서비스에 접속하는 포트**
    * **``AGE`` : 생성 후 지난 시간**

---

* **로컬서버의 8080 포트를 에코 서버의 8080포트로 ``포트 포워딩`` 해주기 위한 명령어**

    ```
    $ kubectl port-forward svc/nasaecho 8080:8080
    ```

    ```
    [root@nasa-master ~]# kubectl port-forward svc/nasaecho 8080:8080
    Forwarding from 127.0.0.1:8080 -> 8080
    Forwarding from [::1]:8080 -> 8080
    ```

* **curl http://localhost:8080 으로 데이터를 땡겨오면 정상적이다!**

    ![스크린샷, 2020-09-16 13-59-00](https://user-images.githubusercontent.com/69498804/93294177-ca041e00-f824-11ea-91e7-02ca68d9225a.png)

---

* **에코 서버의 실행 중 로그를 수집하려면 아래 명령어를 입력하면 확인할 수 있습니다.**

    ```
    $ kubectl logs -f echoserver
    ```

    ```
    [root@nasa-master ~]# kubectl logs -f nasaecho
    Generating self-signed cert
    Generating a 2048 bit RSA private key
    .......+++
    ..+++
    writing new private key to '/certs/privateKey.key'
    -----
    Starting nginx
    127.0.0.1 - - [16/Sep/2020:04:57:55 +0000] "GET / HTTP/1.1" 200 414 "-" "curl/7.29.0"
    127.0.0.1 - - [16/Sep/2020:04:58:27 +0000] "GET / HTTP/1.1" 200 414 "-" "curl/7.29.0"
    127.0.0.1 - - [16/Sep/2020:04:58:40 +0000] "GET / HTTP/1.1" 200 414 "-" "curl/7.29.0"
    ```

---

* **만들어진 nasaecho pod를 지워보도록 하겠습니다.**

    ```
    $ kubectl delete pod echoserver
    ```

    ```
    [root@nasa-master ~]# kubectl delete pod nasaecho
    pod "nasaecho" deleted
    [root@nasa-master ~]# kubectl get pod
    No resources found.
    ```
    **정상적으로 삭제 되었고 ``get``명령으로 확인결과 pod가 없어졌습니다!!**


* **pod가 삭제되었으니 이번에는 서비스 또한 삭제해보겠습니다**

    ```
    [root@nasa-master ~]# kubectl delete svc nasaecho
    service "nasaecho" deleted
    [root@nasa-master ~]# 
    [root@nasa-master ~]# kubectl get svc
    NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
    kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   23d
    ```

    **이와 같이 간단한 실습으로 간단한 사용법에 대해서 알아보았다**

---

### **``치트시트 내용 정리``** <a name="a3"></a>

* ### **``명령어[COMMAND] 종류``**
    **kubectl의 명령어 종류와 문법을 간략히 설명합니다.**


    |명령어 |  문법 |설명 |
    |-----|-------|-----|---------|
    |annotate|	kubectl annotate (-f FILENAME \| TYPE NAME \| TYPE/NAME) KEY_1=VAL_1 ... KEY_N=VAL_N [--overwrite] [--all] [--resource-version=version] [flags]|하나 혹은 여러 리소스에 주석을 추가/업데이트|
    |api-versions|	kubectl api-versions [flags]|사용가능한 API version 조회|
    |apply	|kubectl apply -f FILENAME [flags]|	변경된 리소스 수정 적용하기|
    |attach|	kubectl attach POD -c CONTAINER [-i] [-t] [flags]|	현재 실행중인 컨테이너에 접속 혹은 output stream 확인
    |autoscale	|kubectl autoscale (-f FILENAME \| TYPE NAME \| TYPE/NAME) [--min=MINPODS] --max=MAXPODS [--cpu-percent=CPU] [flags]|	RC(replication controller)을 활용하여 pod auto scale 기능 활성화
    |cluster-info	|kubectl cluster-info [flags]|	쿠버네티스 클러스터에 정보조회
    |config	|kubectl config SUBCOMMAND [flags]|	kubeconfig 파일 수정
    |create	|kubectl create -f FILENAME [flags]	|리소스 file 생성
    |delete	|kubectl delete (-f FILENAME \| TYPE [NAME \| /NAME \| -l label \| --all]) [flags]	|생성(활성화된) 리소스 제거
    |describe	|kubectl describe (-f FILENAME \| TYPE [NAME_PREFIX \| /NAME \| -l label]) [flags]|	리소스 상태 조회
    |edit	|kubectl edit (-f FILENAME \| TYPE NAME \| TYPE/NAME) [flags]	|리소스에 대해 수정 및 적용
    |exec	|kubectl exec POD [-c CONTAINER] [-i] [-t] [flags] [-- COMMAND [args...]]	|pod 내부의 컨테이너에 명령어 날리기
    |explain	|kubectl explain [--include-extended-apis=true] [--recursive=false] [flags]	|리소스(pod, node, service) 에 대한 documentation 확인
    |expose	|kubectl expose (-f FILENAME \| TYPE NAME \| TYPE/NAME) [--port=port] [--protocol=TCP\|UDP] [--target-port=number-or-name] [--name=name] [----external-ip=external-ip-of-service] [--type=type] [flags]	|rc, service, pod 조회(?)
    |get	|kubectl get (-f FILENAME \| TYPE [NAME \| /NAME \| -l label]) [--watch] [--sort-by=FIELD] [[-o \| --output]=OUTPUT_FORMAT] [flags]	|리소스 리스트 조회
    |label	|kubectl label (-f FILENAME \| TYPE NAME \| TYPE/NAME) KEY_1=VAL_1 ... KEY_N=VAL_N [--overwrite] [--all] [--resource-version=version] [flags]	|리소스 label 업데이트 혹은 추가기능
    |logs	|kubectl logs POD [-c CONTAINER] [--follow] [flags]|pod 내부 container 로그확인
    |patch	|kubectl patch (-f FILENAME \| TYPE NAME \| TYPE/NAME) --patch PATCH [flags]|	리소스의 일부 attribute를 수정, 적용          
    |port-forward	|kubectl port-forward POD [LOCAL_PORT:]REMOTE_PORT [...[LOCAL_PORT_N:]REMOTE_PORT_N] [flags]	|포트포워딩 기능
    |proxy|	kubectl proxy [--port=PORT] [--www=static-dir] [--www-prefix=prefix] [--api-prefix=prefix] [flags]	|쿠버네티스에 프록시 설정
    |replace	|kubectl replace -f FILENAME	리소스 재구성(새로 적용)
    |rolling-update|	kubectl rolling-update OLD_CONTROLLER_NAME ([NEW_CONTROLLER_NAME] --image=NEW_CONTAINER_IMAGE \| -f NEW_CONTROLLER_SPEC) [flags]|롤링 업데이트 수행 기능
    |run|kubectl run NAME --image=image [--env="key=value"] [--port=port] [--replicas=replicas] [--dry-run=bool] [--overrides=inline-json] [flags]	|클러스터에 특정 이미지 run
    |scale|	kubectl scale (-f FILENAME \| TYPE NAME \| TYPE/NAME) --replicas=COUNT [--resource-version=version] [--current-replicas=count] [flags]|	RC의 replication 갯수 업데이트
    |stop	|kubectl stop	|더 이상 사용하지 않음 kubectl delete 사용!.
    |version	|kubectl version [--client] [flags]	| 쿠버네티스 버젼 확인|


---

<br/>


* ### **``리소스[RESOURCE] 종류``**

    **kubectl에 적용 가능한 쿠버네티스 리소스 종류와 단축어 리스트 입니다.**


    |리소스 종류|	단축어|
    |-----|---------|
    |apiservices	| 
    |certificatesigningrequests|	csr
    |clusters	 |
    |clusterrolebindings	| 
    |clusterroles	| 
    |componentstatuses|	cs
    |configmaps|	cm
    |controllerrevisions	 |
    |cronjobs	 |
    |customresourcedefinition	|crd
    |daemonsets	|ds
    |deployments|	deploy
    |endpoints|	ep
    |events|	ev
    |horizontalpodautoscalers	|hpa
    |ingresses	|ing
    |jobs	 |
    |limitranges	|limits
    |namespaces	|ns
    |networkpolicies	|netpol
    |nodes	|no
    |persistentvolumeclaims|	pvc
    |persistentvolumes	|pv
    |poddisruptionbudget	|pdb
    |podpreset	 |
    |pods|	po
    |podsecuritypolicies	|psp
    |podtemplates	| 
    |replicasets|	rs
    |replicationcontrollers	|rc
    |resourcequotas	|quota
    |rolebindings	| 
    |roles	 |
    |secrets|	 
    |serviceaccounts	|sa
    |services	|svc
    |statefulsets	 |
    |storageclasses	 |

---

<br/>
 

* ### **``Output 옵션``**
    **kubectl으로 얻은 여러 정보들을 file로 저장하기를 원할 수 있다. 
    이때 아래와 같은 옵션으로 추출 가능합니다.**

 
    ```
    kubectl [command] [TYPE] [NAME] -o=<output_format>
    ```


* **``output_format으로 아래와 같은 format들을 지원.``**


    |Output| 포맷설명|
    |-----|-------|
    | -o=custom-columns=(spec)	| comma로 구분가능한 custom형식의 table을 조회|
    | -o=custom-columns-file=(filename)	| comma로 구분가능한 custom형식의 table을 file로 저장|
    | -o=json	| json 형식의 API obejct로 저장 |
    | -o=jsonpath=(template) |jsonpath 형식으로 조회|
    |-o=jsonpath-file=(filename)	|jsonpath 형식으로 file로 저장
    |-o=name|	리소스 이름만 조회
    |-o=wide	|pod, node 이름 등 추가적인 정보 모두 조회
    |-o=yaml	|yaml 형식의 API object로 저장

* **output 옵션 예제**

    ```
    $ kubectl get pod web-pod-13je7 -o=yaml
    ```
    **다음의 명령은 단일 파드에 대한 세부 정보를 YAML 형식의 오브젝트로 출력한다.**


---

<br/>


* ### **``kubectl 예제``**



    * **kubectl create**

    ```
    // example-service.yaml 파일이름의 서비스를 생성합니다.
    $ kubectl create -f example-service.yaml

    // example-controller.yaml 파일이름의 RC를 생성합니다.
    $ kubectl create -f example-controller.yaml
    ```

    * **kubectl get**

    ```
    // pod list를 출력
    $ kubectl get pods

    // pod list(+ 추가적인 정보 node 이름 등)를 출력
    $ kubectl get pods -o wide

    // 특정 <rc-name>의 정보를 출력
    $ kubectl get replicationcontroller <rc-name>

    // 모든 rc, service들 정보를 출력
    $ kubectl get rc,services

    // 모든 ds(daemon sets)에 대한 정보를 출력(uninitialized ds도 포함)
    $ kubectl get ds --include-uninitialized

    // 특정 node(server01)에 배포된 pod 정보를 출력
    $ kubectl get pods --field-selector=spec.nodeName=server01
    ```

    * **kubectl describe**

    ```
    // 특정 <node-name>의 node 정보 출력
    $ kubectl describe nodes <node-name>

    // 특정 <pod-name>의 pod 정보 출력
    $ kubectl describe pods/<pod-name>

    // 특정 <rc-name>의 rc가 제어하는 pod들 정보 출력
    $ kubectl describe pods <rc-name>

    // 모든 pod 정보 출력(uninitialized pod은 제외)
    $ kubectl describe pods --include-uninitialized=false
    ```

    * **kubectl delete**

    ```
    // pod.yaml로 선언된 pod들을 제거
    $ kubectl delete -f pod.yaml

    // 특정 <label-name>이 정의된 pod, service들 제거
    $ kubectl delete pods,services -l name=<label-name>

    // 특정 <label-name>이 정의된 pod, service들 제거(uninitialized pod, service 포함)
    $ kubectl delete pods,services -l name=<label-name> --include-uninitialized

    // 모든 pod 
    $ kubectl delete pods --all
    ```


    * **kubectl exec**

    ```
    // 특정 <pod-name>을 가진 pod의 첫번째 container에 'date' 라는 명령어 호출
    $ kubectl exec <pod-name> date

    // 특정 <pod-name>을 가진 pod의 특정 <container-name>이라는 이름의 container에 'date' 라는 명령어 호출
    $ kubectl exec <pod-name> -c <container-name> date

    // 특정 <pod-name>을 가진 pod의 첫번째 container에 bash shell실행 
    $ kubectl exec -ti <pod-name> /bin/bash
    ```
 

    * **kubectl logs**

    ```
    // 특정 <pod-name> 이름을 가진 pod의 로그 조회
    $ kubectl logs <pod-name>

    // 특정 <pod-name> 이름을 가진 pod의 로그 tail -f 조회
    $ kubectl logs -f <pod-name>
    ```