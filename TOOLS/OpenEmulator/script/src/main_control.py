'''
Date: 2022-04-27 21:02:24
LastEditTime: 2022-06-07 18:45:44
Description: file content
'''
from src.startup import *
from src.stop import *


#初始化文件
def init_file(projectPath):

    tsnlightPath = projectPath + "/tsn_applications/tsnlight"
    dataPath = projectPath + "/data/"
    simPath = projectPath +"/sim_project"


    os.chdir(dataPath)
    os.system("rm ./data* && rm ./time.txt && touch data010.txt && touch data211.txt")
    os.system("touch data110.txt && touch data210.txt && touch data018.txt &&  touch data118.txt && touch data218.txt && touch data012.txt && touch data112.txt && touch data212.txt && touch time.txt ")
    
    os.chdir(tsnlightPath)
    os.system("rm ./debug_error.txt && touch ./debug_error.txt")

    pathOfOpenSync = projectPath + "/tsn_applications/ptp_bc"
    os.system("rm ./debug_error.txt && touch ./debug_error.txt")

    os.chdir(simPath)
    os.system("rm -rf ./wave* ./novas* ./simv_1* ./*.log ./csrc ./simprofile_dir ./verdiLog ./ucli.key ./profileReport*")




def startup(projectPath, appPath):
    run_sim(projectPath, appPath)
    run_tsnlight(projectPath)
    run_opensync(projectPath)


def stop():
    kill_opensync()
    kill_tsnlight()
    kill_interlock()
    kill_sim()
    print("----------------------------------------------------------------------------------------------------------")
    print("----------------------------------------------------------------------------------------------------------")
