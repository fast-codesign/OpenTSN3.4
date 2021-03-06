'''
Date: 2022-04-27 21:02:24
LastEditTime: 2022-05-20 19:22:22
Description: file content
'''
import src.tool as tool

from subprocess import Popen, PIPE, STDOUT
import os


def run_sim(projectPath, appPath):
    print("----------------------------------------------------------------------------------------------------------")
    print("Co-Emulation env is launching......\nIt may TAKE A WHILE......")

    pathOfSim = projectPath + "/sim_project"
    # pathOfInterlock = projectPath + "/tsn_net_emulator/emulation_lock"
    pathOfInterlock = projectPath.rsplit("/", 1)[0] + "/src/emulation_lock"

    os.chdir(pathOfSim)
    # run_sim = os.system("gnome-terminal -e 'make clean com sim' ")
    run_sim = os.system("nohup make clean com sim >/dev/null 2>&1 &")

    os.chdir(pathOfInterlock)
    # run_interlock = os.system("gnome-terminal -e './interlock'")
    run_interlock  = os.system("nohup ./interlock >/dev/null 2>&1 &")

    while (1):
        simTime = tool.getNanoSec(projectPath + '/data/time.txt', appPath)
        if simTime is not None:
            print("Co-Emulation env sucessfully lunched!")
            break
        else:
            continue

    return


def run_tsnlight(projectPath):
    print("----------------------------------------------------------------------------------------------------------")
    print("Now TSNlight is now CONFIGURING the TSN......\nIt may TAKE A LITTLE LONG TIME......")
    pathOfTSNlight = projectPath + "/tsn_applications/tsnlight"

    os.chdir(pathOfTSNlight)

    # run_tsnlight = os.system("gnome-terminal -e './tsnlight a'")
    run_tsnlight = os.system("nohup ./tsnlight a > /dev/null 2>&1 &")

    while (1):
        with open(pathOfTSNlight + '/debug_error.txt', 'r', encoding="utf-8") as f:
            if "SYNC_INIT_S" in f.read():
                # print(f.read())
                # print("----------------------------------------------------------------------------------------------------------")
                print("TSNlight successfully completed the configuration!")
                break
    return


def run_opensync(projectPath):
    pathOfOpenSync = projectPath + "/tsn_applications/ptp_bc"
    os.chdir(pathOfOpenSync)
    cmd = "./ptp_app a"
    print("----------------------------------------------------------------------------------------------------------")
    print("Now PTP_BC is running...")
    run_ptp_bc = os.system("gnome-terminal -e \'" + cmd + "\'")
    while (1):
        with open(pathOfOpenSync + '/debug_error.txt', 'r', encoding="utf-8") as f:
            if "init finish,start timer and receive pkt" in f.read():
                # print(f.read())
                # print("PTP_BC successfully lunched!")
                break

    pathOfOpenSync = projectPath + "/tsn_applications/ptp"
    os.chdir(pathOfOpenSync)
    cmd = "./ptp_app a"
    print("Now PTP is running...")

    print_type = 1

    #???GUI??????PTP??????
    if print_type == 0:
        p = Popen(cmd, stdout=PIPE, stderr=STDOUT, shell=True)
        while True:
            print((p.stdout.readline()).decode("utf-8"), end="")

    #?????????????????????????????????PTP??????
    elif print_type == 1:
        run_ptp = os.system("gnome-terminal -e \'" + cmd + "\'")

    #???????????????????????????PTP??????
    elif print_type == 2:
        run_ptp = os.system(cmd)

    #?????????PTP?????????
    else:
        run_ptp = os.system("nohup " + cmd + " >/dev/null 2>&1 &")
    


    return
