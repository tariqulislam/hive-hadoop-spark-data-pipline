SET hivevar:DATABASE_NAME=diabetic_analysis;
SET hivevar:TBL_PATIENTS_CHILDREN = ${DATABASE_NAME}.tbl_patients_children;
CREATE TABLE IF NOT EXISTS ${TBL_PATIENTS_CHILDREN} (
  gender STRING,
  region STRING,
  chidren INTEGER
)
PARTITIONED BY (dt STRING)
TBLPROPERTIES('transactional'='false');
