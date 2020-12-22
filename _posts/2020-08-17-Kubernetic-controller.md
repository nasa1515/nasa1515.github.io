---

layout: post
title: "[Kubernetes] - 컨트롤러"
author: Lee Wonseok
categories: Kubernetes
date: 2020-08-17 14:36
comments: true
cover: "/assets/kubernets.jpg"
tags: Kubernetes

---



#  KUBERNETES - 컨트롤러   

**머리말**  

이전 포스트에서는 POD를 직접 수동으로 생성, 관리 하는 방법을 알아보았다.  
이번 포스트에서는 자동적으로 POD 및 시스템을 관리 할 수 있는 컨트롤러에 대해서 알아보자

---


**목차**

- [라이브니스 프로브](#a1)
- [레플리카셋](#a2)
- [데몬셋](#a3)
- [잡(JOB)](#a3)
- [크론잡(CRONJOB)](#a3)


---

## 라이브니스 프로브 <a name="a1"></a>


* **``라이브니스 프로브 개념``**

    **사용자가 모든 오브젝트를 일일이 관리할 수는 없다.  
    관리하고자 하더라도 사용자 시각의 사각지대에 있는 오브젝트를  
    실제 프로덕션 환경에서 관리하기 위해서는 수동 작업은 권장되지 않는다.**

    **실제 환경에서는 자동적으로 정상적이고 안정적인 상태가 유지되어야 한다.  
     쿠버네티스가 이러한 요구를 충족시키기 위해서 사용하는 것이 라이브니스 프로브이다.**


    * **라이브니스 프로브는 파드에 의해 컨테이너를 동작시키고  
    동작중인 컨테이너의 상태를 주기적으로 모니터링한다.  
    파드에서 오류가 발생하면 해당 컨테이너를 재시작시킨다.  
    쿠버네티스의 핵심이라고 할 수 있는 동작이 바로 이 라이브니스 프로브 덕분에 가능한 것이다.**

​

* **라이브니스 프로브는 세 가지 방식으로 컨테이너의 상태를 모니터링한다.**

    - **``HTTP GET 프로브`` : HTTP 요청 / 응답으로 확인**

    - **``TCP 소켓 프로브`` : 포트 연결 시도해서 확인**

    - **``Exec 프로브`` : 컨테이너 내부의 바이너리를 실행하고 종료 코드 확인**  
    
    
    
    **라이브니스 프로브는 현재 동작중인 파드의 상태를 감지하고 재시작 하는데서 그 역할을 다 하지만  
        여러 사유로 인해 파드가 삭제되거나 노드 자체에 장애가 발생하는 경우에는 파드를 재시작 할 수 없다.  
        이러한 상황에 대비해 가용성을 높이기 위해서는 RC, RS, DS 등의 컨트롤러를 사용해야 한다.**

---

 * **라이브니스 프로브 생성**

    **라이브니스 프로브 생성 - ``정상 상태``**


    ```
    apiVersion: v1
    kind: Pod
    metadata:
    name: nasa-pod-liveness
    spec:
    containers:
    - image: nginx:latest
        name: nasa
        ports:
        - containerPort: 8080
        protocol: TCP
        livenessProbe:
        httpGet:
            path: /
            port: 8080
    ```

    **HTTP GET 프로브를 사용하였으며, 경로는 / 포트는 8080이다**.

    * **컨피그 설명**

        * **``livenessProbe``: 라이브니스 프로브 정의** 
        * **``httpGet`` : HTTP GET 프로브 정의**
        * **``tcpSocket`` : TCP 소켓 프로브 정의** 
        * **``Exec``: Exec 프로브 정의**


---

<br/>

* **작성한 YAML 파일로 POD를 생성한다**

    ```
    [root@nasa-master nasa]# kubectl apply -f nasa-pod-liveness.yml 
    pod/nasa-pod-liveness created
    [root@nasa-master nasa]# kubectl get pods --watch
    NAME                READY   STATUS    RESTARTS   AGE
    nasa-pod-liveness   1/1     Running   0          19s
    ```

* **라이브니스의 확인을 위해 ``--watch`` 옵션을 사용해 지속적으로 모니터링!**



---

<br/>

* **정상적인 상태를 확인했으니 비정상 상태를 만들어 보겠습니다.**


    ```
    apiVersion: v1
    kind: Pod
    metadata:
    name: nasa-pod-liveness-error
    spec:
    containers:
    - image: nginx:latest
        name: nasa
        ports:
        - containerPort: 8081
        protocol: TCP
        livenessProbe:
        httpGet:
            path: /
            port: 8082
    ```
    **위의 YAML파일과 모두 동일하지만 ``PORT``를 임의로 다르게 주어 ``error``상태 발생**

<br/>


* **POD 를 생성 후 모니터링 해보겠습니다**

    ```
    [root@nasa-master nasa]# kubectl apply -f nasa-pod-livness-error.yml 
    pod/nasa-pod-liveness-error created
    ```

    ```
    [root@nasa-master nasa]# kubectl get pods --watch
    NAME                  READY   STATUS    RESTARTS   AGE
    nasa-pod-liveness   1/1     Running   0          30s
    nasa-pod-liveness-error   0/1     Pending   0          0s
    nasa-pod-liveness-error   0/1     Pending   0          0s
    nasa-pod-liveness-error   0/1     ContainerCreating   0          0s
    nasa-pod-liveness-error   1/1     Running             0          5s
    nasa-pod-liveness-error   1/1     Running             1          62s
    nasa-pod-liveness-error   1/1     Running             2          2m1s
    nasa-pod-liveness-error   1/1     Running             3          3m1s

    ```

    **WATCH로 모니터링중이던 터미널을 확인해보면 변화가 생겼다.  
    RESTARTS 필드가 0 에서 양수로 변경된 것은 라이브니스 프로브가 해당 파드를  
    이상이 있는 것으로 판단하고 재시작 시도중임을 의미한다.**


    ```
    nasa-pod-liveness-error   1/1     Running             4          4m2s
    nasa-pod-liveness-error   1/1     Running             5          5m1s
    nasa-pod-liveness-error   0/1     CrashLoopBackOff    5          5m58s
    ```
    **잠시 후에 다시 확인해보면 상태가 CrashLoopBackOff 인 것을 확인할 수 있다.**

---

<br/>

* **POD의 Describe를 확인해보자**

    ```
    [root@nasa-master nasa]# kubectl describe pods nasa-pod-liveness-error
        ...
        ...
        State:          Running
        Started:      Fri, 17 Aug 2020 05:12:20 +0000
        Last State:     Terminated
        Reason:       Error
        Exit Code:    137
        Started:      Fri, 17 Aug 2020 05:11:20 +0000
        Finished:     Fri, 17 Aug 2020 05:12:16 +0000
        Ready:          True
        Restart Count:  3
    ```

    **Exit Code는 프로세스를 종료하기 위한 코드이다(137=128+9 , 9번 시그널 : SIGKILL)**  

    **``종류``**

     * **delay**
     * **timeout**
     * **period 가 추가로 존재 한다.**  
        
        **컨테이너 실행 후로부터 모니터링을 시작하기까지 시간을 delay  
         모니터링사이에 시간 간격을 timeout으로 표기한다.  
         파드가 실행되고 난 후로부터 어플리케이션이 제대로 동작하기까지  
         시간이 걸릴 수 있으므로 초기 지연 시간을 initialDlaySecond 로 정의할 수 있다.  
         Event 필드는 파드의 상태를 시간대별로 확인할 수 있으며 이 경우 라이브니스 프로브에 문제가 있다는 사실을 확인할 수 있다.  
         이들은 모두 yaml파일에 정의할 수 있는 내용들이다.**

---

### **``레플리카셋``** <a name="a2"></a>

**쿠버네티스가 처음 나왔을 때는 파드를 복제하고 항상성을 유지시키기 위한 수단은  
``레플리케이션 컨트롤러``가 유일했습니다**  

**그러나 레플리케이션 컨트롤러의 몇몇 문제점과 기능 개선을 위해  
레플리카셋이라는 컨트롤러가 추가되었습니다.  
최근에는 레플리케이션 컨트롤러를 사용하지 않고 대부분 레플리카셋을 사용하기에  
이번 포스트에서는 레플리케이션 컨트롤러에 대해서 다루진 않겠습니다.  
뭐 어짜피 둘이 거의 비슷합니다!**

​

* **레플리케이션 컨트롤러와 레플리카셋의 비교**


    - **``파드의 다중 레이블 지원``**

    - **``파드에 설정된 레이블의 키만 선택 가능``**

    **레플리케이션 컨트롤러에서는 파드의 여러 레이블 중 하나의 레이블에 대해서만  
    레이블 셀렉터로 관리 파드를 지정할 수 있었고   
    반드시 레이블의 key=value가 모두 일치해야만 파드를 지정할 수 있었습니다.  
    그러나 레플리카셋은 다중 레이블을 지정할 수 있고  
    key만 가지고도 레이블을 지정할 수 있습니다.**

---

<br/>

* **레플리카셋 생성**

    ```
    apiVersion: apps/v1 
    kind: ReplicaSet 
    metadata: 
    name: replicaset-nasa 
    spec: 
    replicas: 3 
    selector: 
        matchLabels: 
        app: nasa-nginx-pods-label 
    template: 
        metadata: 
        name: nasa-nginx-pod 
        labels: 
            app: nasa-nginx-pods-label 
        spec: 
        containers: 
        - name: replicaset-nasa 
            image: nginx:latest 
            ports: 
            - containerPort: 80
    ```

    **레플리케이션 컨트롤러에서는 레이블 셀렉터 항목에 레이블을 직접 지정하지만   
    레플리카셋은 ``matchLabels`` 및 ``matchExpressions`` 필드로 ``레이블을 선택``한다.  
    레플리카셋의 레이블 셀렉터는 kubectl explain replicaset.spec.selector로 지정할 수 있다.**


    **pod와 다르게 추가된 내용만 있습니다.  
    replicas는 생성할 pod의 개수를 설정합니다.  
    그리고 레플리카가 포드를 생성할 때 사용할 템플릿을 정의합니다.** 

---

* **생성 후 RS확인**

    ```
    [root@nasa-master nasa]# kubectl apply -f nasa-rs.yml 
    replicaset.apps/replicaset-nasa created
    ```

    **레플리카셋 동작 확인**
    ```
    [root@nasa-master nasa]# kubectl get replicasets.apps
    NAME              DESIRED   CURRENT   READY   AGE
    replicaset-nasa   3         3         3       3m9s
    ```

    **POD 확인**
    ```
    [root@nasa-master nasa]# kubectl get po
    NAME                    READY   STATUS    RESTARTS   AGE
    replicaset-nasa-7fvdx   1/1     Running   0          2m21s
    replicaset-nasa-gbft4   1/1     Running   0          2m21s
    replicaset-nasa-r84dt   1/1     Running   0          2m21s
    ```

    **모두 정상적을 동작 한다!! 하지만 RS의 기능 중의 하나를 더 알아 봅시다!**

---

* **레플리카셋 ``레이블 셀렉터`` 사용**

    * **``matchLabels`` 레이블 셀렉터**

    **matLabels 레이블 셀렉터는 오브젝트 파일에서 다음과 같은 형식으로 정의한다.**

    ```
    ...
    spec:
    selector:
        matchLabels:
        key: value
    ...
    ```

    **matchLabels로 레이블 셀렉터를 사용하는 경우  
    레플리케이션 컨트롤러와 레플리카셋이 동일하게 동작한다.**


* **``matchExpressions`` 레이블 셀렉터**

    ```
    spec:
    selector:
        matchExpressions:
        - key: <stirng>
        operator: <In | NotIn | Exists | DoesNotExist>
        values:
        - <string>
    ```
    
    **위의 매치레이블과 다른 점은 ``key``와 ``values``를 따로 지정한다는 점이다.  
    operator 필드는 key와 value 사이의 연산을 담당하는 부분으로  
    아래 네 가지 중 하나를 선택해서 매칭시킬 수 있다.**

    ```
    In : 레이블의 키와 값이 지정된 값으로 일치해야 함

    NotIn: 레이블의 키와 값이 지정된 값과 일치하지 않아야 함

    Exists: 레이블의 키가 포함되어야 함

    DoesNotExists: 레이블의 키가 포함되지 않아야 함

    ```

---

* **이번에는 같은 label을 갖고있는 replicas의 수를 증가시켜보겠습니다.**  

    **yaml 파일의 replicas를 4로 변경하고 다시 실행하면 변경된 것을 확인 할 수 있습니다.** 


    ```
    replicas: 4 
    ```

    ```
    [root@nasa-master nasa]# vim nasa-rs.yml 
    [root@nasa-master nasa]# 
    [root@nasa-master nasa]# kubectl apply -f nasa-rs.yml 
    replicaset.apps/replicaset-nasa configured
    ```

    **이전에는 ``created``라는 출력이 나왔는데  
    이번에는 ``configured``라는 출력이 나왔습니다.**


    ```
    [root@nasa-master nasa]# kubectl get po
    NAME                    READY   STATUS    RESTARTS   AGE
    replicaset-nasa-bpmbg   1/1     Running   0          52s
    replicaset-nasa-lkv4h   1/1     Running   0          32s
    replicaset-nasa-s2tlp   1/1     Running   0          52s
    replicaset-nasa-wxhq6   1/1     Running   0          52s
    ```
    **POD도 확인해보면 이전에 생성되었던 POD는 종료되지 않고  
    새로운 POD만 추가 실행 된 것을 확인 할 수 있습니다.**

---

* **``동작 원리``**  

    **레플리카셋은 자동으로 복구해주고 생성을 확인하는 것을 보면 ``tracking`` 하고 있는 것 같습니다.**

    **이러한 것은 어떻게 이루어 지는 것일까요??**

    **이는 레플리카셋이 라벨셀렉터로 같은 라벨을 갖고 있는 포드들을 계속 확인합니다.  
    실제로 동일한 라벨이 설정한 라플리카 개수만큼 다시 복구해줍니다.  
    그리고 동일한 포드의 개수가 레플리카에 설정한 개수와 같다면 특별한 작업을 진행하지 않습니다.** 

    **결론적으로 레플리카셋은 포드의 개수를 일정한 개수를 유지하는 기능을 합니다.**

 
 <br/>

* **그리고 추가로 pod의 metadata 변경도 가능합니다.** 

    **``edit`` 옵션을 사용해 특정 POD의 라벨을 edit-test로 바꾸어 보았습니다**

    ```
    [root@nasa-master nasa]# kubectl edit pod replicaset-nasa-bpmbg
    pod/replicaset-nasa-bpmbg edited
    [root@nasa-master nasa]# 
    [root@nasa-master nasa]# kubectl get po
    NAME                    READY   STATUS              RESTARTS   AGE
    replicaset-nasa-72hgn   0/1     ContainerCreating   0          4s
    replicaset-nasa-bpmbg   1/1     Running             0          6m5s
    replicaset-nasa-lkv4h   1/1     Running             0          5m45s
    replicaset-nasa-s2tlp   1/1     Running             0          6m5s
    replicaset-nasa-wxhq6   1/1     Running             0          6m5s
    [root@nasa-master nasa]#
    [root@nasa-master nasa]#
    [root@nasa-master nasa]#
    [root@nasa-master nasa]# kubectl get po --show-labels
    NAME                    READY   STATUS    RESTARTS   AGE     LABELS
    replicaset-nasa-72hgn   1/1     Running   0          66s     app=nasa-nginx-pods-label
    replicaset-nasa-bpmbg   1/1     Running   0          7m7s    app=edit-test
    replicaset-nasa-lkv4h   1/1     Running   0          6m47s   app=nasa-nginx-pods-label
    replicaset-nasa-s2tlp   1/1     Running   0          7m7s    app=nasa-nginx-pods-label
    replicaset-nasa-wxhq6   1/1     Running   0          7m7s    app=nasa-nginx-pods-label
    ```

---

### **``데몬셋``** <a name="a3"></a>

**데몬셋은 모든 노드가 파드의 사본을 실행하도록 하는 역할을 한다.  
쿠버네티스 클러스터에서 노드가 추가되면 파드도 추가된다.  
노드가 클러스터에서 제거되면 해당 파드는 가비지(garbage)로 넘어간다.  
데몬셋을 삭제하면 데몬셋이 생성한 파드들도 정리된다.**  

**대몬셋의 정확한 용도는 다음과 같다.**

​

- **모든 노드에서 클러스터 스토리지 데몬 실행**

- **모든 노드에서 로그 수집 데몬 실행**

- **모든 노드에서 노드 모니터링 데몬 실행**

​

**이러한 작업의 처리를 위해서 모든 노드 단위로 커버하는 데몬셋이 사용된다.**

```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: nasa-ds
spec:
  selector:
    matchLabels:
      app: nasa-ds
  template:
    metadata:
      labels:
        app: nasa-ds
    spec:
      nodeSelector:
        node: nasa  
      containers:
      - name: nasa
        image: nginx:latest
        ports:
          - containerPort: 80
```

* **apiVersion apps/v1 → 쿠버네티스의 apps/v1 API를 사용 합니다.**

* **kind: DaemonSet → DaemonSet의 작업으로 명시 합니다.**

* **metadata.name → DaemonSet의 이름을 설정 합니다.**

* **metadata.namespace → 네임스페이스를 지정 합니다.**

* **metadata.labels → DaemonSet를 식별할 수 있는 레이블을 지정 합니다.**

* **spec.selector.matchLabels → 어떤 레이블의 파드를 선택하여 관리할 지 설정 합니다.**

* **spec.template.metadata.labels.name → 생성할 파드의 레이블을 파드명: " " 으로 지정 합니다.**

* **spec.template.spec.containers → 하위 옵션들은 컨테이너의 설정을 정의합니다.**


---

<br/>

* **데몬 셋 생성**

    ```
    [root@nasa-master nasa]# kubectl apply -f nasa-ds.yml 
    daemonset.apps/nasa-ds created

    [root@nasa-master nasa]# kubectl get ds
    NAME      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
    nasa-ds   0         0         0       0            0           node=nasa       32s
    ```

    **시간이 충분이 지난 후에도 ``DESIRED, CURRENT, READY`` 탭의 값이 모두 0이다.  
     파드가 아예 생성되지 않는다.  
     이유는 오브젝트를 정의할 때 노드 셀렉터로 node=nasa 레이블을 선택하도록 했기에  
    매칭되는 노드가 없으므로 아무 POD도 생성되지 않은 것이다.**

---

<br/>

* **데몬 셋 동작을 위해 노드를 지정해보자**

    ```
    [root@nasa-master nasa]# kubectl label nodes nasa-node1 node=nasa
    node/nasa-node1 labeled

    ```


* **다시 한번 데몬 셋을 확인해보자**

    ```
    [root@nasa-master nasa]# kubectl get nodes nasa-node1 --show-labels
    NAME         STATUS   ROLES    AGE   VERSION   LABELS
    nasa-node1   Ready    <none>   24d   v1.15.5   ... .... ,node=nasa
    ```
    ```
    [root@nasa-master nasa]# kubectl get daemonsets.apps 
    NAME      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
    nasa-ds   1         1         1       1            1           node=nasa       6m1s
    ```

* **데몬 셋이 동작함에 의해 POD가 1개 생성 되었다**

    ```
    [root@nasa-master nasa]# kubectl get pods
    NAME                    READY   STATUS    RESTARTS   AGE
    nasa-ds-7jsgd           1/1     Running   0          106s
    ```

* **테스트를 모두 완료했으니 NODE와 DS를 삭제한다!**

```
[root@nasa-master nasa]# kubectl label nodes nasa-node1 node-
node/nasa-node1 labeled
```

---


### **``잡``** <a name="a4"></a>

**JOB 컨트롤러는 파드의(컨테이너)의 어플리케이션(JOB) 실행이 완료되는 것에 초점을 맞춘 컨트롤러이다.  
즉, 끝이 정해진 작업을 하는 어플리케이션을 잡 컨트롤러가 관리한다.  
파드가 작업을 마치고 성공적으로 종료되면 잡 컨트롤러는 성공적으로 완료된 잡을 추적한다.  
잡을 삭제하면 잡이 생성한 파드도 정리된다.  
물론 파드가 중간에 실패하는 경우 잡 오브젝트는 새로운 파드를 가동시킨다.  
잡은 임시 작업, 배치 작업에 유용하게 사용될 수  있다.**

**​잡 컨트롤러는 RC, RS, DS처럼 계속 동작하는 방식이 아니라  
재시작 정책(restartPolicy)을 기본값이 Always가 아닌 Onfailuer나 Never로 선언해야 한다.  
이렇게 하면 잡 컨트롤러의 파드는 재실행되지 않는다.**

* **job.spec.template.spec.restartPolicy** 

    - **Always : 종료/실패시 항상 재시작(default)**

    - **Onfailure: 실패식 재시작 (정상 종료시 재시작하지 않음)**

    - **Never : 종료 또는 오류 발생시 재시작하지 않음**

---

* **잡 컨트롤러 생성**

    ```
    apiVersion: batch/v1
    kind: Job
    metadata:
    name: nasa-job
    spec:
    template:
        metadata:
        labels:
            app: nasa-job
        spec:
        restartPolicy: OnFailure
        containers:
        - name: nasa
            image: busybox
            command: ["sleep", "60"]
    ```

    ```
    [root@nasa-master nasa]# kubectl apply -f nasa-jop.yml 
    job.batch/nasa-job created
    ```

* **잡 컨트롤러를 확인해보자**

    ```
    [root@nasa-master nasa]# kubectl get job.batch
    NAME       COMPLETIONS   DURATION   AGE
    nasa-job   0/1           33s        33s


    [root@nasa-master nasa]# kubectl get pods
    NAME             READY   STATUS    RESTARTS   AGE
    nasa-job-84s8x   1/1     Running   0          40s
    ```

    **하나의 파드가 있고 아직 잡이 완료되지 않아서 COMPLETIONS에 0/1이라고 표기된다.  
    파드는 정상 동작중이다.**


    ```
    [root@nasa-master nasa]# kubectl get job.batch
    NAME       COMPLETIONS   DURATION   AGE
    nasa-job   1/1           64s        104s
    [root@nasa-master nasa]# 


    [root@nasa-master nasa]# kubectl get pods
    NAME             READY   STATUS      RESTARTS   AGE
    nasa-job-84s8x   0/1     Completed   0          107s
    ```

    **잠시 후에 파드를 다시 확인 해보니 STATUS가 Completed로 표기되고**  

    **잡 컨트롤러에서도 확인해보니 COMPLETIONS가 1/1로 바뀌었다.  
    잡이 완료되었음을 알 수 있다.**

---

<br/>

* **다중 잡 컨트롤러**

    ```
    spec:
    completions: 3
    ```
    **``completions: 3`` 설정만 YAML 파일에 추가해주면 여러 번의 작업을 값만 큼 순차적으로 실행한다.  
    하나의 파드가 생성되어 잡이 실행되고 완료되면 두 번째 파드가 생성되고 완료되고 ,  
    그 다음 파드가 생성되고 완료되기를 지정된 횟수만큼 반복하는 것이다.**


* **병렬 다중 잡 컨트롤러**

    ```
    spec:
    completions: 3
    parallelism: 3
    ```
    **병렬로 처리하기 위해서는 `` parallelism: 3`` 설정을 추가해주면 된다**  

    **그럼 3개의 3이 동시에 3번의 작업을 진행한다!!**


---

### **``크론잡``** <a name="a5"></a>


**잡 컨트롤러에서 잡을 실행하는 목적은 끝이 있는 작업을 하는 어플리케이션 때문이다.  
 크론잡은 이름에서 알 수 있듯이 주기적으로 반복된 작업을 하며,  
 그 작업이 시작과 끝이 있는 작업일 때 사용한다.  
 ``리눅스의 crontab과 같다.``**  


 * **이론 보다는 실습!! 바로 크론잡을 생성해보자**

    ```
    apiVersion: batch/v1beta1
    kind: CronJob
    metadata:
    name: hello World
    spec:
    schedule: "*/1 * * * *"
    jobTemplate:
        spec:
        template:
            spec:
            containers:
            - name: hello World
                image: busybox
                args:
                - /bin/sh
                - -c
                - date; echo Hello NASA! from the Kubernetes cluster
            restartPolicy: OnFailure
    ```
    **가장 중요한 부분은 스케줄 필드로, cronjob.spec.schedule 필드를 사용해 주기적인 시간을 구성한다.  
    스케줄을 구성하는 값은 다섯 개의 필드로 구분되어 다음과 같은 순서이다.**

    **``그냥 리눅스랑 똑같다!``**

    - **분**

    - **시**

    - **일**

    - **월**

    - **요일(0 : 일요일, 1: 월요일, 6: 토요일)**


    ```
    [root@nasa-master nasa]# kubectl apply -f nasa-cron.yml 
    cronjob.batch/hello created
    ```

* **생성 후 크론 잡 컨트롤러 및 파드 확인**

    ```
    [root@nasa-master nasa]# kubectl get cronjobs.batch
    NAME    SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
    hello   */1 * * * *   False     0        <none>          28s
    ```

    **최초 생성된 직후 ACTIVE 상태의 잡은 없다.   
    마지막으로 동작한 LAST SCHEDULE도 없다.   
    잠시 기다린 후에 다시 조회해보면 다음과 같이 변한다.**

    ```
    [root@nasa-master nasa]# kubectl get cronjobs.batch
    NAME    SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
    hello   */1 * * * *   False     1        10s             4m
    ```

* **파드를 조회해보면 다음과 같다**

    ```
    [root@nasa-master nasa]# kubectl get po
    \NAME                     READY   STATUS      RESTARTS   AGE
    hello-1600331820-5jmd4   0/1     Completed   0          2m36s
    hello-1600331880-jhs6s   0/1     Completed   0          96s
    hello-1600331940-kkzwh   0/1     Completed   0          36s
    ```

----

* **크론잡 컨트롤러의 제한사항**

    **크론잡 컨트롤러는 일정 실행시간마다 하나의 잡 오브젝트를 생성한다.  
    특정한 상황에서는 하나가 아닌 여러 개의 잡이 생성되는 경우도 있다.  
    이러한 상황을 제어하기 위해서 크론잡 컨트롤러에서는 잡의 제한사항을 지정할 수 있다.**

​

* **``cronjob.spec.startingDeadlineSeconds`` : 시작 데드라인 시간**  
**어떤 이유든 예정된 시간에 잡을 시작해야 하는 데드라인.  
초단위로 입력해서 현재로부터 n초 안에 일정을 놓친 잡이 있는지 확인.**

​

* **``cronjob.spec.concurrrencyPolicy`` : 동시 실행 정책**  

    - **Allow: 잡이 동시 실행될 수 있음(default)**

    - **Forbid: 동시 실행 금지. 잡이 아직 완료되지 않은 경우 다음 잡을 건너 뜀.**

    - **Replace: 현재 실행중인 잡을 취소하고 새 잡으로 교체**  
    
    **위 설정들을 쉽게 예를 들어보자면  
    startingDeadlineSeconds가 100초이고, concurrencyPolicy가 Allow이면  
    이전에 놓친 잡이 있으면 해당 잡을 실행하게 된다.**

    ```
    spec:
    schedule: "*/1 * * * *"
    startingDeadlineSeconds: 10
    concurrencyPolicy: Forbid
    ```

---

