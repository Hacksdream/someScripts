create user 'slave1'@'%' identified by '123456';
grant replication slave, replication client on *.* to 'slave1'@'%';

create user 'slave2'@'%' identified by '123456';
grant replication slave, replication client on *.* to 'slave2'@'%';
flush privileges;
