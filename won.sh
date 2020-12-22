#!/bin/sh



# Create by 이원석 (CCCR)



# check root

if [ "$USER" != "root" ]
then
	echo "root 권한으로 스크립트를 실행하여 주십시오."
        exit
fi

rm -rf homep.txt


result=`hostname`"_result_"`date +%F__%T`.txt




echo > $result 2>&1
echo "**********************************************************************"
echo "*                    리눅스 취약점 진단 스크립트                     *"
echo "**********************************************************************"
echo "*   결과는 hostname_result_시간.txt  파일로 저장 됩니다              *"
echo "**********************************************************************"
echo ""
sleep 2
echo "############################# 시작 시간 ##############################"  >> $result 2>&1
date >> $result 2>&1
echo "************************** 취약점 체크 시작 **************************" >> $result 2>&1
echo >> $result 2>&1


echo "01. root 계정 원격 접속 제한 ">> $result 2>&1

grep ^pts /etc/securetty > /dev/null 2>&1

if [ $? -eq 0 ];then
        echo "    ==> [취약] root 직접 접속이 허용되었거나, 원격서비스를 사용 중 입니다." >> $result 2>&1
        echo "    ==> [취약] vi /etc/securetty 파일에서 pts 주석처리." >> $result 2>&1
else
        echo "    ==> [안전] 원격 서비스를 사용하지 않고 있거나, 접속이 차단 되어 있습니다." >> $result 2>&1
fi

echo >> $result 2>&1

cat /etc/pam.d/login | grep "^auth required /lib/security/pam_securetty.so" > /dev/null 2>&1 

if [ $? -eq 0 ];then
        echo "    ==> [안전] pam_securetty.so 파일을 통해 사용자 인증에 대한 보안이 적용 >> $result 2>&1
되어 있습니다."
else
        echo "    ==> [취약] pam_securetty.so 파일을 통한 사용자 인증에 대한 보안이 적용되어 있지 않습니다." >> $result 2>&1
        echo "    ==> [취약] vi /etc/pam.d/login 파일에서 해당 내용을 추가하거나 주석을 해제하십시오." >> $result 2>&1
        echo "    ==> [취약] auth required /lib/security/pam_securetty.so" >> $result 2>&1
fi

echo >> $result 2>&1





echo "02. 패스워드 복합성 설정(및 정책)" >> $result 2>&1
max=`cat /etc/login.defs | grep PASS_MAX_DAYS | awk '{print $2}' | sed '1d'`
min=`cat /etc/login.defs | grep PASS_MIN_DAYS | awk '{print $2}' | sed '1d'`
date=`cat /etc/login.defs | grep PASS_WARN_AGE | awk '{print $2}' | sed '1d'`



if [ $max = 60 ]
then
        echo "    ==> [안전] 최대 사용 기간          : $max"일"" >> $result 2>&1
else 
        echo "    ==> [취약] 최대 사용 기간          : $max"일"" >> $result 2>&1
fi
if [ $min = 1 ]
then
        echo "    ==> [안전] 최소 사용 시간          : $min"일"" >> $result 2>&1
else
        echo "    ==> [취약] 최소 사용 시간          : $min"일"" >> $result 2>&1
fi
if [ $date = 7 ] 
then
        echo "    ==> [안전] 기간 만료 경고 기간(일) : $date"일"" >> $result 2>&1
else
        echo "    ==> [취약] 기간 만료 경고 기간(일) : $date"일"" >> $result 2>&1
fi


echo >> $result 2>&1
echo



echo "04. 패스워드 파일 보호" >> $result 2>&1
if [ "`cat /etc/passwd | grep "^root" | awk -F: '{print $2}'`" = x ]
        then
                if test -r /etc/shadow
                        then
                                echo "    ==> [안전] Shadow 패스워드 시스템을 사용중입니다" >> $result 2>&1
                        else
                                echo "    ==> [취약] Passwd 패스워드 시스템을 사용중입니다" > $result 2>&1
                fi
fi
echo >> $result 2>&1



echo "06. 파일 및 디렉터리 소유자 설정" >> $result 2>&1


find / \( -nouser -o -nogroup \) -xdev -ls > /dev/null 2>&1

if [ "$?" -eq 0 ]
then
    echo "    ==> [안전] 소유자 혹은 그룹이 없는 파일 및 디렉터리가 존재하지 않습니다" >> $result 2>&1
else
    echo "    ==> [취약] 소유자 혹은 그룹이 없는 파일 및 디렉터리가 존재합니다" >> $result 2>&1
fi

echo >> $result 2>&1




echo "08. /etc/shadow 파일 소유자 및 권한 설정" >> $result 2>&1
if test `ls -l /etc/shadow | awk {'print $1'} ` = -r--------.
        then
                echo "    ==> [안전] 권한   :  "`ls -l /etc/shadow | awk {'print $1'}` >> $result 2>&1
else
        if test `ls -l /etc/shadow | awk {'print $1'} ` = ----------.
                then
                        echo "    ==> [안전] 권한   :  "`ls -l /etc/shadow | awk {'print $1'}` >> $result 2>&1
                else
                        echo "    ==> [취약] 권한   :  "`ls -l /etc/shadow | awk {'print $1'}` >> $result 2>&1
        fi
fi
if test `ls -l /etc/shadow | awk {'print $3'}` = root
        then
                echo "    ==> [안전] 소유자 : " `ls -l /etc/shadow | awk {'print $3'}` >> $result 2>&1
        else
                echo "    ==> [취약] 소유자 : " `ls -l /etc/shadow | awk {'print $3'}` >> $result 2>&1
fi
if test `ls -l /etc/shadow | awk {'print $4'} ` = root 
        then
                echo "    ==> [안전] 그룹   :  "`ls -l /etc/shadow | awk {'print $4'}` >> $result 2>&1
        else
                echo "    ==> [취약] 그룹   :  "`ls -l /etc/shadow | awk {'print $4'}` >> $result 2>&1
fi
echo >> $result 2>&1
echo




echo "10. /etc/(x)inetd.conf 파일 소유자 및 권한 설정" >> $result 2>&1
echo >> $result 2>&1
if test -f /etc/inetd.conf
        then
                echo "    ==> [안전] inetd.conf 파일이 존재합니다" >> $result 2>&1
                root=`ls -l /etc/inetd.conf | awk '{print $3}'`
                per=`ls -l /etc/inetd.conf | awk '{print $1}'`
                if [ $root = root ]
                        then
                                echo "    ==> [안전] inetd.conf 파일 소유자 : " $IO >> $result 2>&1
                        else
                                echo "    ==> [취약] inetd.conf 파일 소유자 : " $IO >> $result 2>&1
                fi
        if [ $per = -rw-------. ]
                then
                        echo "    ==> [안전] inetd.conf 파일 권한   : " $IP >> $result 2>&1
                else
                        echo "    ==> [취약] inetd.conf 파일 권한   : " $IP >> $result 2>&1
        fi
else
        echo "    ==> [취약] inetd.conf 파일이 존재하지 않습니다" >> $result  2>&1
fi
if test -f /etc/xinetd.conf
        then
                echo "    ==> [안전] xinetd.conf 파일이 존재합니다" >> $result 2>&1
                xroot=`ls -l /etc/xinetd.conf | awk '{print $3}'`
                xper=`ls -l /etc/xinetd.conf | awk '{print $1}'`
                if [ $xroot = root ]
                        then
                                echo "    ==> [안전] xinetd.conf 파일 소유자 : " $XO >> $result 2>&1
                        else
                                echo "    ==> [취약] xinetd.conf 파일 소유자 : " $XO >> $result 2>&1
                fi
        if [ $xper = -rw-------. ]
                then
                        echo "    ==> [안전] xinetd.conf 파일 권한   : " $XP >> $result 2>&1
                else
                        echo "    ==> [취약] xinetd.conf 파일 권한   : " $XP >> $result 2>&1
        fi
else
        echo "    ==> [취약] xinetd.conf 파일이 존재하지 않습니다" >> $result 2>&1
fi
echo
echo >> $result 2>&1



echo "12. /etc/services 파일 소유자 및 권한 설정" >> $result 2>&1

root=`ls -l /etc/services | awk '{print $3}'`
per=`ls -l /etc/services | awk '{print $1}'`

if [ $root = root ]
	then
		echo "    ==> [안전] services 파일 소유자 : " $root >> $result 2>&1
	else
		echo "    ==> [취약] services 파일 소유자 : " $root >> $result 2>&1
fi

if [ $per = -rw-r--r--. ]
	then
		echo "    ==> [안전] services 파일 권한   : " $per >> $result 2>&1
	else
		echo "    ==> [취약] services 파일 권한   : " $per >> $result 2>&1
fi

echo
echo >> $result 2>&1


echo "14. 사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정" >> $result 2>&1

ls -lart ~/.* | sed '/^$/d' |awk 'BEGIN{OFS=";"}{print $1,$4,$9}' | egrep -v "^d|^l" | egrep -v "/|tota
l" | grep -w "r" >> homep.txt




for i in `cat homep.txt`
do
	
	id2=`echo $i | cut -d";" -f2`
	a=`echo $i | cut -d";" -f1`
	hper=`echo $i | cut -d";" -f1 | cut -c 9`
	name=`echo $i | cut -d";" -f3`

if [ "$USER" = "$id2" ] && [ "$hper" != "w" ] 
	then
		echo "    ==> [안전] 소유자, 권한이 안전합니다.    "파일 : "$name" >> $result 2>&1  
	
	elif [ "$USER" = "$id2" ]
	then
		echo "    ==> [취약] 소유자는 동일하나 권한이 다릅니다.   "권한 : " $a "파일 : "$name"  >> $result 2>&1
		
	else
		echo "    ==> [취약] 다른 소유자 파일입니다.     "소유자 : " $id2 "파일 : "$name " >> $result 2>&1
fi

done

echo >> $result 2>&1

echo "16. /dev에 존재하지 않는 device 파일 점검" >> $result 2>&1
touch Device_file.txt
DF="Device_file.txt"
find /dev -type f -exec ls -l {} \; > $DF
check=`ls -l Device_file.txt | awk '{print $5}'`
check2=`cat Device_file.txt`

if [ $check = 0 ] 
	then
		 echo "    ==> [안전] 존재하지 않는 파일이 없습니다."  >> $result 2>&1
		 rm -rf $DF
	else
		 rm -rf $DF
		 echo "    ==> [취약] 존재하지 않는 파일이 있습니다 : $check2"  >> $result 2>&1
fi

echo
echo >> $result 2>&1
