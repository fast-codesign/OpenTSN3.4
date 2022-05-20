'''
Date: 2022-04-27 21:02:24
LastEditTime: 2022-04-29 10:11:40
Description: file content
'''
from src.startup import *
from src.stop import *


#初始化文件
def init_file(projectPath):

    tsnlightPath = projectPath + "/tsn_applications/tsnlight"
    dataPath = projectPath + "/data/"

    os.chdir(dataPath)
    os.system("rm ./data* && rm ./time.txt && touch data011.txt")
    os.system("touch data111.txt && touch data211.txt && touch data018.txt &&  touch data118.txt && touch data218.txt && touch time.txt ")

    os.chdir(tsnlightPath)
    os.system("rm ./debug_error.txt && touch ./debug_error.txt")


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
