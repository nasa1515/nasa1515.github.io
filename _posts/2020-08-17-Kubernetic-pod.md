---
layout: post
title: "[Kubernetes] - POD"
author: Lee Wonseok
categories: Kubernetes
date: 2020-08-17 12:36
comments: true
cover: "/assets/kubernets.jpg"
tags: Kubernetes
---



#  KUBERNETES - POD   

**머리말**  
이제 기본적인 개념과 kubectl 명령어까지 모두 알아봤다!!  
이번 포스트부터는 진짜 실습을 들어가보자!!  
우선 컨포넌트 포스트에서 설명했던 것들부터 시작!!


---


**목차**

- [POD?1](#a1)
- [파드는 어떻게 다중 컨테이너를 관리하는 걸까?](#a2)
- [파드 생성 실습](#a3)
- [컨테이너 두개 이상을 포함한 pod 만들기](#a4)
---

## POD?! <a name="a1"></a>

**``Pod``은 쿠버네티스 애플리케이션의 기본 실행 단위인데  
쉽게 말해 쿠버네티스 워크로드에서 관리할 수 있는 가장 작은 단위가 파드이다.  
또한 배포 시 배포의 단위가 되기도 한다.  
파드는 하나 이상의 '동작중인' 컨테이너를 포함하고 있는 오브젝트이다.  
하나의 파드에는 하나의 컨테이너를 배치하는 것이 기본이다.  
쿠버네티스 클러스터 내에서 파드는 주로 두 가지 방법으로 사용된다.**

![스크린샷, 2020-09-16 15-29-48](https://user-images.githubusercontent.com/69498804/93300290-78ae5b80-f831-11ea-8075-020c2856cdec.png)



* **``Pod 모델 종류``**



    **1. ``1개 컨테이너`` - 1개 POD 모델**  
    **"one-container-per-Pod"은 쿠버네티스에서 가장 널리 쓰이는 케이스.**  
    **한개의 pod이 1개의 container을 감싸고 있으며, 쿠버네티스가 pod을 관리.**



    **2. ``2개 이상 컨테이너`` - 1개 POD 모델**

    **2개 이상의 container가 리소스를 밀접하게 공유해야하는 상황에 쓰인다.**  
    **하나의 컨테이너가 file을 제공해주면 "sidecar" 역할을 하는 컨테이너가 해당 file에 접근하는 개념이다.  
    이러한 방식으로 추상화, 캡슐화 된 pod은 reliable한 application동작으로 이끌거나  
    robust system으로 만드는 등 장점으로 승화시킨다.**

    **즉 쉽게 말해 서로 의존성이 있는 다중 컨테이너가 동작중인 파드.  
    리소스 공유가 필요한 결합 서비스 단위인 경우일 것이다.**


    * **``부가 설명``**
    
        **기본적으로 하나의 컨테이너에는 최소한의 필요한 기능  
        즉 하나의 컨테이너는 하나의 기능만 하는 것이 기본이다.  
        그런데 VM에 익숙해지다 보니 착각하는 것이  
        하나의 컨테이너에 여러 개의 어플리케이션을 돌리면 효율적이지 않겠냐는 의문이 있을 수 있다.  
        하지만 Dockerfile의 메커니즘 자체가 그렇듯  
        하나의 컨테이너는 하나의 어플리케이션만 띄울 수 있도록 설계되어 있다.  
        쉘 스크립트나 docker-compose를 이용해서 동시에 여러 동작을 유발할 수는 있지만 원칙은 그렇다  
        컨테이너는 유연하게 확장/축소가 가능하다는 것이 장점이다.  
        만약 하나의 컨테이너에 웹서버와 디비서버 어플리케이션 서버를 다 박아두는 것은  
        컨테이너를 쓰는 가장 기본적인 목적인 ``'어플리케이션의 격리'``를 져버리는 것이다.  
        쉽게 설명하면, 파드가 사용되는 방식 중 하나인 ``'다중 컨테이너의 동작'``은  
        ``'멀티 컨테이너'``이지 마구잡이로 여러개를 돌리는 것과는 다르다.**

        **또한 파트에 하나 이상의 컨테이너가 있다고 하더라도,  
        파드의 컨테이너는 같은 노드에서만 동작하고,  
        하나의 파드에 있는 다중 컨테이너는 저장소, 네트워크 IP 등을 공유한다!!**

---

 * ### **``파드는 어떻게 다중 컨테이너를 관리할까?``** <a name="a2"></a>


    **파드는 애초에 결합성이 있는 서비스를 위해 다중 컨테이너를 지원하도록 디자인 되었다.  
    예를 들어, 공유 볼륨 내부 파일의 웹 서버 역할을 하는 컨테이너와  
    원격 소스로부터 그 파일들을 업데이트하는 분리된 "사이드카" 컨테이너가 있는 경우  
    아래 다이어그램의 모습일 것이다.**  

    ![스크린샷, 2020-09-16 15-49-34](https://user-images.githubusercontent.com/69498804/93302001-3a666b80-f834-11ea-9021-efe70f1ac329.png)  

    **위의 그림에서 web server가 추가로 필요하게 되면 file puller도 같이 하나가 파드단위로 증가하게 된다.  
    이러한 패턴을 ``'사이드 카'`` 패턴이라고 한다.  
    단, 쿠버네티스 공식문서에서는 결합성이 강해 어쩔 수 없는 경우만 사용하도록 권고하고 있다.  
    이 때, 파드는 파드 안에 속해 있는 컨테이너들 사이에 두 가지의 공유 리소스를 제공한다.**  

    **``네트워킹``과 ``저장소``이다.**

​

* **``네트워킹``**  

    **각 파드는 고유한 IP를 할당받는다.  
    한 파드 안에 있는 모든 컨테이너는 네트워크 네임스페이스와 IP주소와 포트를 공유한다.  
     파드 안의 컨테이너끼리는 localhost를 이용해서 통신할 수 있다.  
     파드 밖의 요소와 파드 안의 컨테이너가 통신하기 위해서는  
     포트 정보와 같은 네트워크 리소스 사용 상태를 서로 공유하고 있어야 한다.**

​

* **``저장소``**

    **파드 내부의 모든 컨테이너는 공유 볼륨에 접근할 수 있고  
    그 컨테이너끼리 데이터를 공유할 수 있다.  
    또한 볼륨은 컨테이너가 재시작 되더라도 파드 안의 데이터를 영구적으로 유지할 수 있게 한다.**

​

* **``파드의 Lifecycle``**

    **일단 파드가 생성되면 파드에는 고유한 ID가 할당되고, 노드에 스케줄링 된다.  
    해당 노드가 종료되면 해당 노드에 스케줄링 되어있던 파드는 일정 시간이 지난 후 삭제된다.  
    노드가 삭제된다고 해서 소속되어있던 파드가 리스케줄링 되지 않으며  
    필요시 완전히 새로운 파드를 다시 생성하는 방식이다.**  
    
    **같은 이유로 파드는 문제가 발생하더라도 자가 복구하지 않는다.  
    만약 파드의 동작이 실패하는 경우, 파드는 삭제되어버린다.  
    이와 같은 파드 인스턴스를 관리하는 동작을 컨트롤러가 한다.**

    
    **즉, 파드는 사용자나 컨트롤러가 명시적으로 삭제하기 전까지는 남아 있게 된다.**

​

* **``파드의 의미``**  

    **파드는 응집력 있는 서비스 단위를 형성하는 여러 개의 협력 프로세스를 모델로 한다.  
    파드는 그 구성 요소 집합보다 높은 수준의 추상화를 제공함으로써 애플리케이션 배포 및 관리를 단순화한다.  
    파드는 전개 단위, 수평 확장 및 복제를 한다. 공동 스케줄링, 공유된 생애주기  
    (예: 종료), 조정된 복제, 자원 공유 및 종속성 관리는 파드의 컨테이너에 대해 자동으로 처리된다.**

​

* **``파드의 종료``**

    * **``절차``**

        **파드는 쿠버네티스 클러스터의 노드에서 실행 중인 프로세스이다.  
        이러한 프로세스가 더이상 필요하지 않을 때는 정상 종료시켜야 한다.  
        사용자가 삭제를 요청할 수 있어야 하고,  
        프로세스가 종료되는 것을 알 수 있어야 하며,  
        삭제가 완료된 것을 확인할 수 있어야 한다.  
        사용자가 파드 삭제 요청을 하면 시스템은 파드가 종료되기 전에  
        정리를 위한 유예 기간을 두었다가,  
        KILL 시그널이 해당 프로세스로 전송되면 파드가 API 서버에서 삭제된다.**

        ​
        ```
        - 사용자의 삭제 명령(default 유예기간: 30초)

        - 유예기간이 지난 파드 정보가 갱신

        - 이 파드는 조회시 Terminating이라는 문구 출력

        - Terminating으로 표시되는 것을 확인하면 kubelet은 종료 작업 시작

        - 종료한 파드는 엔드포인트 리스트에서 제거되며, 레플리케이션 컨트롤러의 관리 대상에서 제외

        - 만약 도중에 유예 기간이 만료되면 파드에서 실행중이던 모든 프로세스에 SIGKILL이 떨어짐

        - kubelet은 유예기간을 0으로 세팅해서 API 서버로부터 파드를 즉시 삭제할 수 있음. 이제 파드는 더이상 보이지 않음.
        ```
        ​

    * **``강제 삭제``**

        **기본적으로 삭제 작업은 30초 이내에 끝이 난다.**  
        **kubectl delete 명령은 --grace-period={second} 옵션을 지원하는데,  
        이 옵션은 기본 설정된 값을 사용자가 정의할 수 있도록 하는 옵션으로,  
        0이 되면 파드는 즉시 삭제된다.**  
        **kubectl 1.5버전 이상에서는 강제 삭제를 위해서 반드시  
        --grace-period=<second>와 함께 --force를 같이 사용해야 한다.**  
        
        **파드를 강제 삭제하면 API서버는 kubelet으로부터  
        실행중이던 파드가 종료되었다는 통지를 기다리지 않는다.  
        API단에서 파드를 즉시 제거해버리기 때문에  
        동일한 이름으로 새 파드를 만들 수도 있다.**


---

* ### **``파드 생성 실습``** <a name="a3"></a>


 * **``kubectl explain`` 명령으로 파드 리소스의 필드를 확인 해보자!.**

    ```
    [root@nasa-master ~]# kubectl explain pod.spec.containers
    KIND:     Pod
    VERSION:  v1

    RESOURCE: containers <[]Object>

    DESCRIPTION:
        List of containers belonging to the pod. Containers cannot currently be
        added or removed. There must be at least one container in a Pod. Cannot be
        updated.

        A single application container that you want to run within a pod.

    FIELDS:
    image	<string>
        Docker image name. More info:
        https://kubernetes.io/docs/concepts/containers/images This field is
        optional to allow higher level config management to default or override
        container images in workload controllers like Deployments and StatefulSets.
    ...
    ```

* **이제 연습삼아 POD를 정의하는 ``yaml``파일을 만들어보자!**

    ```
    apiVersion: v1 
    kind: Pod 
    metadata: 
    name: nasa-nginx-pod 
    spec: 
    containers: 
    - name: nasa-nginx-container 
        image: nginx:latest 
        ports: 
        - containerPort: 80 
            protocol: TCP
    ```


    **위 yaml 파일을 세부적으로 설명해봅시다!**

    * **``apiVersion`` : YAML 파일에서 정의한 오브젝트의 API 버전을 나타냅니다.**

    * **``kind`` : 이 리소스의 종류를 나타냅니다.  
    현재는 pod를 생성하기 때문에 pod로 작성했습니다.  
    다른 오브젝트의 종류는 kubectl api-resources 명령어를 통해 확인할 수 있습니다.**

    * **``metadata``: 라벨, 주석, 이름과 같은 리소스의 부가 정보들을 입력합니다.** 

    * **``spec``: 리소스를 생성하기 위한 자세한 정보를 입력합니다.  
    생성되는 container의 이름, 이미지, 포트 등을 설정할 수 있습니다.** 

        ```
        pod.spec.containers : 컨테이너 정의
        pod.spec.containers.image: 컨테이너에 사용할 이미지
        pod.spec.containers.name: 컨테이너 이름
        pod.spec.containers.ports: 노출할 포트 정의
        pod.spec.containers.ports.containerPort: 노출할 컨테이너 포트번호
        pod.spec.containers.ports.protocol: 노출할 컨테이너 포트의 기본 프로토콜
        ```

* **작성한 ``YAML``파일을 기반으로 POD를 생성해보겠습니다**

    ```
    kubectl apply -f yaml 파일이름
    ```

    ```
    [root@nasa-master nasa]# kubectl apply -f nasa.yml 
    pod/nasa-nginx-pod created
    ```

* **파드 동작상태 확인**

    ```
    [root@nasa-master nasa]# kubectl get po
    NAME             READY   STATUS    RESTARTS   AGE
    nasa-nginx-pod   1/1     Running   0          64s
    ```

* **실행중인 파드 정의 확인**   

    **``-o ``옵션에는 yaml과 json 중 하나를 선택할 수 있다**


    ```
    [root@nasa-master nasa]# kubectl get pods nasa-nginx-pod -o yaml
    apiVersion: v1
    kind: Pod
    metadata:
    annotations:
        kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"name":"nasa-nginx-pod","nam
    espace":"default"},"spec":{"containers":[{"image":"nginx:latest","name":"nasa-nginx-container",
    "ports":[{"containerPort":80,"protocol":"TCP"}]}]}}
    creationTimestamp: "2020-09-16T07:26:45Z"
    name: nasa-nginx-pod
    namespace: default
    resourceVersion: "39554"
    selfLink: /api/v1/namespaces/default/pods/nasa-nginx-pod
    uid: 148bfb1a-73ad-4c44-805d-300cb5be8af8
    spec:
    containers:
    - image: nginx:latest
        imagePullPolicy: Always
        name: nasa-nginx-container
        ports:
        - containerPort: 80
        protocol: TCP
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
        name: default-token-556xc
        readOnly: true
    dnsPolicy: ClusterFirst
    enableServiceLinks: true
    nodeName: nasa-node3
    priority: 0
    restartPolicy: Always
    schedulerName: default-scheduler
    securityContext: {}
    serviceAccount: default
    serviceAccountName: default
    terminationGracePeriodSeconds: 30
    tolerations:
    - effect: NoExecute
        key: node.kubernetes.io/not-ready
        operator: Exists
        tolerationSeconds: 300
    ``` 


* **파드의 describe 확인**

    ```
    [root@nasa-master nasa]# kubectl describe pods nasa-nginx-pod
    Name:         nasa-nginx-pod
    Namespace:    default
    Priority:     0
    Node:         nasa-node3/10.146.0.9
    Start Time:   Wed, 16 Sep 2020 07:26:45 +0000
    Labels:       <none>
    Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                    {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"name":"nasa-nginx
    -pod","namespace":"default"},"spec":{"containers":[{"image"...
    Status:       Running
    ...
    ```

* **pod도 container와 같이 ``kubectl exec``를 통해 명령어를 실행시킬 수 있습니다.** 

    ```
    kubectl exec -it nasa-nginx-pod bash
    ```

    ```
    [root@nasa-master nasa]# kubectl exec -it nasa-nginx-pod bash
    root@nasa-nginx-pod:/# 
    root@nasa-nginx-pod:/# ls     
    bin   dev                  docker-entrypoint.sh  home  lib64  mnt  proc  run   srv  tmp  var
    boot  docker-entrypoint.d  etc                   lib   media  opt  root  sbin  sys  usr
    ```

* **또 도커와 같이 ``kubectl logs``를 통해 포드의 로그를 확인할 수 있습니다.** 

    ```
    kubectl logs nasa-nginx-pod
    ```

    ```
    [root@nasa-master nasa]#  kubectl logs nasa-nginx-pod
    /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuratio
    n
    /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
    /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
    10-listen-on-ipv6-by-default.sh: Getting the checksum of /etc/nginx/conf.d/default.conf
    10-listen-on-ipv6-by-default.sh: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
    /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
    /docker-entrypoint.sh: Configuration complete; ready for start up
    ```

* **오브젝트는 ``kubectl delete -f`` 명령어로 삭제할 수 있습니다.**

    ```
    [root@nasa-master nasa]# kubectl delete -f nasa.yml 
    pod "nasa-nginx-pod" deleted
    [root@nasa-master nasa]# 
    [root@nasa-master nasa]# kubectl get po
    No resources found.
    ```

---

* ### **컨테이너 두개 이상을 포함한 pod 만들기**  <a name="a4"></a>


* **YAML 파일**

    ```
    apiVersion: v1
    kind: Pod 
    metadata: 
    name: nasa-nginx-pod 
    spec: 
    containers: 
        - name: nasa-nginx-container 
        image: nginx:latest 
        ports: 
            - containerPort: 80 
            protocol: TCP 
        - name: sidecar 
        image: ubuntu:14.04 
        command: ["echo", "hello"] 
        args: ["ubuntu"]
    ```

 
* **다음과 같이 두개가 생성되었고 한개만 실행하고 있는 것을 확인할 수 있습니다.** 

    ```
    [root@nasa-master nasa]# kubectl get po
    NAME             READY   STATUS             RESTARTS   AGE
    nasa-nginx-pod   1/2     CrashLoopBackOff   1          32s
    ```

* **``-c`` 옵션을 사용해 어떤 컨테이너에 접속 할지 확인 가능합니다**  

    ```
    kubectl exec -it nasa-nginx-pod -c sidecar bash
    ```

    ```
    [root@nasa-master nasa]# kubectl exec -it nasa-nginx-pod -c nasa-nginx-container bash
    root@nasa-nginx-pod:/# ls
    bin   dev                  docker-entrypoint.sh  home  lib64  mnt  proc  run   srv  tmp  var
    boot  docker-entrypoint.d  etc                   lib   media  opt  root  sbin  sys  usr
    ```

---