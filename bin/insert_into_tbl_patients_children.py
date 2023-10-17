import subprocess
import os

APP_BASE_DIR="/home/hadoop/diabetic_analysis"

HQL_SCRIPT_NAME="{0}/dml/sc_insert_data_into_patient_children.hql".format(APP_BASE_DIR)
BEELINE_CMD = "beeline -u jdbc:hive2://10.0.2.15:10000 -n hadoop -p ronnie01 ".format(APP_BASE_DIR)

class RunQuery:
    def __init__(self):
        pass

    def cmd_builder(self,dt,file_name):
        return "{0} --hivevar dt={1} -f {2}".format(BEELINE_CMD,dt,file_name)
    def run(self):
        try:
            cmd = self.cmd_builder("2023-10-16", HQL_SCRIPT_NAME)
            print(cmd)
            proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, preexec_fn=os.setsid)

            stdout, stderr = proc.communicate()
            print(stdout)
            if stderr:
                output = stderr.strip()
                value = output.decode("utf-8")
                print(value)
        except subprocess.CalledProcessError as e:
            print(e.output)


if __name__ == "__main__":
    run_query =  RunQuery()
    run_query.run()
