# This Repository is concept of developing the pipeline with hive hadoop with Shell Script ##
[All The documentation to build this application is available in following link](https://tariqul-islam-rony.medium.com/hadoop-hive-shell-script-bash-beeline-and-hiveserver2-data-pipeline-automation-part-2-44cbcc30d0d7)

## Requirements ##
1. Linux
2. Hadoop And Hive Installation
3. Shell Enable
4. Azkaban Scheduler

## Examples and Running Scripts ##

### Create HQL files

```sql
SELECT 
    employee_id as `employe ID`,
    employee_name as `employee Name`,
    department_id as `Department ID`,
    department_name as `Department Name`,
    product_name as `Product Name`,
    sales_count as `Sales Count`,
    sales_price as `Sales Price`,
    total_sales as  `Total Sales`
FROM 
   ${TBL_SALES_REPORT}
WHERE dt='${dt}';

```

### Create Shell File
```bash
#!/bin/bash
set -e
# App root directory
app_root_dir=/home/hadoop/app

# sourcing the log and date function from following below files
source ${app_root_dir}/func/func_logs.sh || { >&2 echo "${app_root_dir}/func/func_logs.sh function file is missing"; exit 1; }
source ${app_root_dir}/func/func_date.sh || { >&2 echo "${app_root_dir}/func/func_date.sh function file is missing"; exit 1; }
# Hive initialization file
_hive_config_file=${app_root_dir}/conf/hive.conf.ini.hql

# shell function for generating the sales report
function main {
    inform "[OP ] Start Generating Report";
    # Take the datetime arguments
    local _dt=
    if [[ $# -eq 0 ]]; then
       error "Please provie date information";
       exit 1;
    elif [[ $# -eq 1 ]]; then
       _dt=$1
    else
       error "Error occured during provide arguments";
       exit 1;
    fi

    inform "[Check ] Start checking Datetime format";

    # check the format of the date
    is_date_yyyy_mm_dd ${_dt} || {
       error "[Invalid] ${_dt} is in invalid format"
       exit 1;
    }
    
    local _HOST_IP="<HiveServer2 IP>:<Running Port>/<Database Name>"
    local _HIVE_USER_NAME=<Hive User name>
    local _HIVE_PASSWORD=<Hive Password>
    # Output format [CSV2, TSV2, CSV, TSV]
    local _OUTPUT_FORMAT=csv2
    # HQL file which contains Query for generate report
    local _HQL_FILE_PATH=${app_root_dir}/dml/generate_sales_report.hql
    # Export to -> which local system folder contains the Generated Report
    local _EXPORT_TO=${app_root_dir}/reports
    # Generated File name with date (CSV formatted file)
    local _EXPORT_FILE=${_EXPORT_TO}/gen_sales_report_${_dt}.csv
 
   
   # create the sample logs for running beeline command
   inform "[CMD]  beeline -u jdbc:hive2://${_HOST_IP} \
     -n ${_HIVE_USER_NAME} \
     -p ${_HIVE_PASSWORD} \
     -i ${_hive_config_file} \
     --outputformat=csv2 \
     --verbose=false \
     --showHeader=true \
     --silent=true \
     --fastConnect=true \
     --hivevar dt=${_dt} \
     -f ${_HQL_FILE_PATH} |  sed '/^$/d' > ${_EXPORT_FILE}"

   # --outputformat = takes the output file format in file system
   # --verbose = print the logs with error and warning, takes (true,false)
   # --showHeader = Add the header row into output File
   # --silent = beeline run without create the logs into terminal
   # --fastConnect = When connecting, skip building a list of all tables 
   # and columns for tab-completion of HiveQL statements (true) 
   # or build the list (false)
   # sed '/^$/d' = Remove blank space and line from output files
   beeline -u jdbc:hive2://${_HOST_IP} \
     -n ${_HIVE_USER_NAME} \
     -p ${_HIVE_PASSWORD} \
     -i ${_hive_config_file} \
     --outputformat=csv2 \
     --verbose=false \
     --showHeader=true \
     --silent=true \
     --fastConnect=true \
     --hivevar dt=${_dt} \
     -f ${_HQL_FILE_PATH} |  sed '/^$/d' > ${_EXPORT_FILE} ||
     {
        error "Something Went Wrong During Generating Report Please see the logs";
        exit 1;
      }


    # Check the Date function
    inform "Report Generated Successfully.";
    inform "[OP ] END"
    
}
main "${@}"
```

### Generating Report

```bash
# Export the _dt (datetime) enviroment variable into Shell
> export _dt=2023-10-10
# Run the following shell file below with datetime argument(_dt) 
> sh /home/hadoop/app/src/exe_generate_sales_report.sh ${_dt}
```

## Azkaban Scheduler
Already has sample for creating the scehduler into `flow` folder
[Azkaban Scehduler file](https://github.com/tariqulislam/hive-hadoop-spark-data-pipline/tree/main/flow)

## Licence
MIT Licence 




