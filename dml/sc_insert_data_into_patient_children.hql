SET hivevar:DATABASE_NAME=diabetic_analysis;
SET hivevar:TBL_PATIENTS=${DATABASE_NAME}.tbl_patients;
SET hivevar:TBL_PATIENTS_CHILDREN=${DATABASE_NAME}.tbl_patients_children;
INSERT OVERWRITE TABLE ${TBL_PATIENTS_CHILDREN} PARTITION (dt='${dt}')
SELECT
  gender,
  children,
  claim
FROM
  ${TBL_PATIENTS}
WHERE dt='${dt}';
