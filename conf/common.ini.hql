-- this must be set to true. Hive uses txn manager to do DML.
SET hive.support.concurrency=true;
SET hive.txn.manager=org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;
-- The follwoing are not required if you are using Hive 2.0
SET hive.enforce.bucketing=true;
SET hive.exec.dynamic.partition.mode=nostrict;
-- required for standalone hive metastore
#SET hive.compactor.initiator.on=true;
#SET hive.compactor.worker.threads=1;
