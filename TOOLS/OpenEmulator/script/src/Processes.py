'''
Date: 2022-06-01 16:37:43
LastEditTime: 2022-06-16 21:40:32
Description: file content
'''

from PyQt5 import QtCore, QtGui, QtWidgets
import os, sys


class Processes(QtCore.QObject):

    outputSignal = QtCore.pyqtSignal(str, int)

    def __init__(self, projectPath, processList):
        super().__init__()
        self.processList = processList
        print(self.processList)
        self.dataPath = projectPath + '/data'
        #TODO:sim
        self.simProcess = QtCore.QProcess()
        self.simPath = self.processList[0]["path"]
        self.simCmd = self.processList[0]["cmd"]
        # self.simCmd = "ping localhost"

        #TODO:lock
        self.lockProcess = QtCore.QProcess()
        self.lockPath = self.processList[1]["path"]
        self.lockCmd = self.processList[1]["cmd"]

        #TODO:tsnlight
        self.tsnLightProcess = QtCore.QProcess()
        self.tsnLightPath = self.processList[2]["path"]
        self.tsnLightCmd = self.processList[2]["cmd"]

        #TODO:ptpbc
        self.ptpbcProcess = QtCore.QProcess()
        self.ptpbcPath = self.processList[3]["path"]
        self.ptpbcCmd = self.processList[3]["cmd"]

        #TODO:ptp
        self.ptpProcess = QtCore.QProcess()
        self.ptpPath = self.processList[4]["path"]
        self.ptpCmd = self.processList[4]["cmd"]

        #TODO:wave
        self.waveProcess = QtCore.QProcess()
        self.wavePath = self.processList[5]["path"]
        self.waveCmd = self.processList[5]["cmd"]

        self.dataPath = projectPath + '/data'

    def initFiles(self):
        os.chdir(self.dataPath)
        dataFileInitList = ["./time.txt", "./data010.txt", "./data110.txt", "./data210.txt", "./data018.txt", "./data118.txt", "./data218.txt", "./data012.txt", "./data112.txt", "./data212.txt"]
        for fileName in dataFileInitList:
            print(fileName)
            cmd = "rm " + str(fileName) + " && touch " + str(fileName)
            os.system(cmd)

        os.chdir(self.processList[0]["path"])
        simFilesReserve = ["file_list.f", "Makefile", "pre_cmd"]
        simFiles = os.listdir(self.simPath)
        for f in simFiles:
            if f not in simFilesReserve:
                os.system("rm -rf " + str(f))

        os.chdir(self.processList[2]["path"])
        os.system("rm ./debug_error.txt ")
        os.system("touch ./debug_error.txt")

        os.chdir(self.processList[3]["path"])
        os.system("rm ./debug_error.txt ")
        os.system("touch ./debug_error.txt")

    def printStdLog(self, process, processNum):
        output = process.readAllStandardOutput()
        output = bytes(output).decode('utf-8')
        self.outputSignal.emit(output, processNum)

    def printErrLog(self, process, processNum):
        output = process.readAllStandardError()
        output = bytes(output).decode('utf-8')
        self.outputSignal.emit(output, processNum)

    def handle_state(self, state):
        states = {
            QtCore.QProcess.NotRunning: 'Not running',
            QtCore.QProcess.Starting: 'Starting',
            QtCore.QProcess.Running: 'Running',
        }
        state_name = states[state]
        print("State changed:", state_name)

    def startProcess(self, process, cmd, path, processNum):
        os.chdir(path)
        process.setProcessChannelMode(QtCore.QProcess.MergedChannels)
        process.readyReadStandardOutput.connect(lambda: self.printStdLog(process, processNum))
        process.readyReadStandardError.connect(lambda: self.printErrLog(process, processNum))
        process.stateChanged.connect(self.handle_state)
        process.start(cmd)

    #根据monitorThread的信号确定调用的外部程序，并调整输出
    def progressCtrl(self, monitorSignal):
        if monitorSignal == 0:
            self.initFiles()
            self.startProcess(self.simProcess, self.simCmd, self.simPath, monitorSignal)
            self.startProcess(self.lockProcess, self.lockCmd, self.lockPath, monitorSignal)
            self.lockProcess.disconnect()
        if monitorSignal == 1:
            self.simProcess.disconnect()
            self.startProcess(self.tsnLightProcess, self.tsnLightCmd, self.tsnLightPath, monitorSignal)
        if monitorSignal == 2:
            # self.tsnLightProcess.disconnect()
            self.startProcess(self.ptpbcProcess, self.ptpbcCmd, self.ptpbcPath, monitorSignal)

        if monitorSignal == 3:
            self.startProcess(self.ptpProcess, self.ptpCmd, self.ptpPath, monitorSignal)

        if monitorSignal == 5:
            # self.startProcess(self.waveProcess, self.waveCmd, self.wavePath)
            os.chdir(self.wavePath)
            os.system(self.waveCmd)

    def killAllProcesses(self):
        try:
            k_sim = self.simProcess.kill()
            k_lock = self.lockProcess.kill()
            k_tsnlight = self.tsnLightProcess.kill()
            k_ptp = self.ptpProcess.kill()
            k_ptp = self.ptpbcProcess.kill()
            os.system("killall -9 simv_1")
            os.system("killall -9 interlock")
            os.system("killall -9 tsnlight")
            os.system("killall -9 ptp_app")
        except Exception as e:
            print(repr(e))
