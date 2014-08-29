cp -r ../tools/packaging/build/package_configs/ubuntu1204/ ../tools/packaging/build/package_configs/ubuntu1404/
cp depends_packages.cfg ../tools/packaging/build/package_configs/ubuntu1404/
sed -i 's/librabbitmq0/librabbitmq1/g' ../tools/packaging/common/debian/contrail-openstack-vrouter/debian/control.in
for i in `ls *.diff`; do echo $i; (cd ../ && cat patcher_1404/$i |patch -p1); done
tar zxvf additional_packages.tar.gz -C /cs-shared/builder/cache/ubuntu1404/icehouse
while IFS= read -r line
do
    packname=`echo $line|awk -F"_" '{print $1}'`
    packversion=`echo $line|awk -F"_" '{print $2}'`
    if [ -a /cs-shared/builder/cache/ubuntu1404/icehouse/$line ]
    then
        echo File $line already exists
    else
        (cd /cs-shared/builder/cache/ubuntu1404/icehouse && apt-get download $packname=$packversion)
    fi
done < <(cat ../tools/packaging/build/package_configs/ubuntu1404/icehouse/depends_packages.cfg  |grep "file  ="|awk '{print $3}')
while IFS= read -r line
do
    newfile=`echo $line|awk -F"%3a" '{print $1":"$2}'`
    (cd /cs-shared/builder/cache/ubuntu1404/icehouse && mv $line $newfile)
done < <((cd /cs-shared/builder/cache/ubuntu1404/icehouse && ls *%3a*))

