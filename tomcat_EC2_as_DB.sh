security group- 22 and 8080 for tomcat server

security group- 22 and 3306 for database server

*in database server

#yum install mariadb-server -y
#systemctl start mariadb
#mysql -h localhost -u root
then after entering into the database
>>create database studentapp;
>>create user 'admin' identified by 'Admin123';
>>grant all privileges on *.* to 'admin';
>>flush privileges;
>>exit;

#mysql_secure_installation
(create password for root)
then press 'y' for every question.



#!/bin/bash

yum install java -y
curl -O https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.77/bin/apache-tomcat-8.5.77.tar.gz
curl -O https://s3-us-west-2.amazonaws.com/studentapi-cit/mysql-connector.jar
curl -O https://s3-us-west-2.amazonaws.com/studentapi-cit/student-rds.sql
curl -O https://s3-us-west-2.amazonaws.com/studentapi-cit/student.war

tar xzf apache-tomcat-8.5.77.tar.gz -C /opt

mv /root/student.war /opt/apache-tomcat-8.5.77/webapps/
mv /root/mysql-connector.jar /opt/apache-tomcat-8.5.77/lib/

/opt/apache-tomcat-8.5.77/bin/catalina.sh start

sed -i '23 i <Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource"' /opt/apache-tomcat-8.5.77/conf/context.xml
sed -i '24 i maxTotal="100" maxIdle="30" maxWaitMillis="10000"' /opt/apache-tomcat-8.5.77/conf/context.xml
sed -i '25 i username="USERNAME" password="PASSWORD" driverClassName="com.mysql.jdbc.Driver"' /opt/apache-tomcat-8.5.77/conf/context.xml
sed -i '26 i url="jdbc:mysql://DB-ENDPOINT:3306/DATABASE"/>' /opt/apache-tomcat-8.5.77/conf/context.xml

sed -i 's/USERNAME/admin/g' /opt/apache-tomcat-8.5.77/conf/context.xml
sed -i 's/PASSWORD/Admin123/g' /opt/apache-tomcat-8.5.77/conf/context.xml
sed -i 's/DB-ENDPOINT/54.173.36.15/g' /opt/apache-tomcat-8.5.77/conf/context.xml
sed -i 's/DATABASE/studentapp/g' /opt/apache-tomcat-8.5.77/conf/context.xml

/opt/apache-tomcat-8.5.77/bin/catalina.sh stop
/opt/apache-tomcat-8.5.77/bin/catalina.sh start

yum install mysql -y
mysql -h 18.234.134.93 -u admin -pAdmin123 studentapp < student-rds.sql
