docker build -t docutee/hadoop-master ./master
docker build -t docutee/hadoop-slave ./slave

rem remove hadoop master container if exists
docker rm -f minhquang-master

rem start hadoop master container
docker run -it ^
--name minhquang-master ^
--hostname minhquang-master ^
--network hadoop-network ^
--network-alias minhquang-master ^
docutee/hadoop-master

rem remove hadoop slave container if exists
docker rm -f minhquang-slave1

rem start hadoop slave container
docker run -d ^
--name minhquang-slave1 ^
--hostname minhquang-slave1 ^
--network hadoop-network ^
--network-alias minhquang-slave1 ^
docutee/hadoop-slave
