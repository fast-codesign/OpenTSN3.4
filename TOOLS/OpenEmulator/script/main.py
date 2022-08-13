'''
Date: 2022-06-02 19:03:19
LastEditTime: 2022-06-16 21:40:23
Description: file content
'''

import contextlib
import sys, os
from PyQt5.QtWidgets import QApplication, QMainWindow, QDialog, QDesktopWidget, QFileDialog
from PyQt5 import QtCore, QtGui
from qdarkstyle.light.palette import LightPalette
import qdarkstyle

from src.EmittingStr import EmittingStr
from src.ProgressMonitor import ProgressMonitor
from src.PathCheck import *
from src.Processes import Processes
from src.Mainwindow import Ui_MainWindow
from src.TimeMonitor import TimeMonitor
from src.Dialogwindow import Ui_Form
from src.InfoDialog import Ui_Dialog
from src.tool import *


class OEMainwindow(QMainWindow, Ui_MainWindow):

    appPath = os.getcwd()
    projectPath = os.getcwd().rsplit("/", 1)[0] + "/demo"
    deadline = 100

    def runtimeInit(self):

        self.progressMonitor = ProgressMonitor(self.projectPath, self.appPath)
        self.externalProcesses = Processes(self.projectPath, self.externalProcessValueList)
        self.timeMonitor = TimeMonitor(self.projectPath, self.appPath)

        self.progressMonitor.progressSignal.connect(self.externalProcesses.progressCtrl)
        self.externalProcesses.outputSignal.connect(self.printLog2Ui)
        self.timeMonitor.newTimeSignal.connect(self.updateTimeLabel)
        self.timeMonitor.stopSignal.connect(self.emuComplete)

    def runtimeCfg(self):
        self.externalProcessValueList = []
        self.externalProcessesUiList = []

        self.emuValue = {"path": f'{self.projectPath}/sim_project', "cmd": "make clean com sim", "enable": True}
        self.lockValue = {"path": self.projectPath.rsplit("/", 1)[0] + "/src/emulation_lock", "cmd": "./interlock", "enable": True}
        self.tsnlightValue = {"path": f'{self.projectPath}/tsn_applications/tsnlight', "cmd": "./tsnlight 1", "enable": True}
        self.ptpBcValue = {"path": f'{self.projectPath}/tsn_applications/ptp_bc', "cmd": "./ptp_app 2", "enable": True}
        self.ptpValue = {"path": f'{self.projectPath}/tsn_applications/ptp', "cmd": "./ptp_app 2", "enable": True}
        self.waveValue = {"path": f'{self.projectPath}/sim_project', "cmd": "make wave", "enable": True}

        self.externalProcessValueList.append(self.emuValue)
        self.externalProcessValueList.append(self.lockValue)
        self.externalProcessValueList.append(self.tsnlightValue)
        self.externalProcessValueList.append(self.ptpBcValue)
        self.externalProcessValueList.append(self.ptpValue)
        self.externalProcessValueList.append(self.waveValue)

        self.emuUi = {"pathEdit": self.emuPath, "selBut": self.emuPathSelBut, "cmdEdit": self.emuCmd}
        self.lockUi = {"pathEdit": self.lockPath, "selBut": self.lockPathSelBut, "cmdEdit": self.lockCmd}
        self.tsnlightUi = {"pathEdit": self.tsnlightPath, "selBut": self.tsnlightPathSelBut, "cmdEdit": self.tsnlightCmd}
        self.ptpBcUi = {"pathEdit": self.ptpBcPath, "selBut": self.ptpBcPathSelBut, "cmdEdit": self.ptpBcCmd}
        self.ptpUi = {"pathEdit": self.ptpPath, "selBut": self.ptpPathSelBut, "cmdEdit": self.ptpCmd}
        self.waveUi = {"pathEdit": self.wavePath, "selBut": self.wavePathSelBut, "cmdEdit": self.waveCmd}
        self.externalProcessesUiList.append(self.emuUi)
        self.externalProcessesUiList.append(self.lockUi)
        self.externalProcessesUiList.append(self.tsnlightUi)
        self.externalProcessesUiList.append(self.ptpBcUi)
        self.externalProcessesUiList.append(self.ptpUi)
        self.externalProcessesUiList.append(self.waveUi)

        #bind ValueList to UiList
        for i in range(len(self.externalProcessValueList)):
            self.externalProcessesUiList[i]["pathEdit"].setText(self.externalProcessValueList[i]["path"])
            self.externalProcessesUiList[i]["cmdEdit"].setText(self.externalProcessValueList[i]["cmd"])
            # if self.externalProcessValueList[i]["enable"] is True:
            #     self.externalProcessesUiList[i]["enableBut"].setChecked(True)

        self.externalProcessesUiList[0]["selBut"].clicked.connect(lambda: self.setProcessPath(0))
        self.externalProcessesUiList[1]["selBut"].clicked.connect(lambda: self.setProcessPath(1))
        self.externalProcessesUiList[2]["selBut"].clicked.connect(lambda: self.setProcessPath(2))
        self.externalProcessesUiList[3]["selBut"].clicked.connect(lambda: self.setProcessPath(3))
        self.externalProcessesUiList[4]["selBut"].clicked.connect(lambda: self.setProcessPath(4))
        self.externalProcessesUiList[5]["selBut"].clicked.connect(lambda: self.setProcessPath(4))

        self.runtimeSaveBut.clicked.connect(self.runtimeSettingsSave)

    def setupUi(self, MainWindow):
        super().setupUi(MainWindow)
        self.ConfirmDialog = QDialog()
        self.ConfirmDialogUi = Ui_Form()
        self.ConfirmDialogUi.setupUi(self.ConfirmDialog)
        self.ConfirmDialogUi.TimeEdit.setText(str(self.deadline))
        self.ConfirmDialogUi.ConfirmBut.clicked.connect(self.deltaAndTimeSave)

        self.InfoDialog = QDialog()
        self.InfoDialogUi = Ui_Dialog()
        self.InfoDialogUi.setupUi(self.InfoDialog)

        self.stopBut.setEnabled(False)
        self.startupBut.clicked.connect(self.ConfirmDialog.show)
        self.stopBut.clicked.connect(self.stop)
        self.showWavesBut.clicked.connect(self.showWaves)
        self.actionExit.triggered.connect(self.exit)
        self.sideBar.itemClicked.connect(self.switchView)
        self.sideBar.setCurrentRow(0)
        self.switchView()
        self.move2Center()

        self.runningLogList = [self.runningLog_1, self.runningLog_2, self.runningLog_3, self.runningLog_4]

    def deltaAndTimeSave(self):
        deadlineInput = self.ConfirmDialogUi.TimeEdit.text()
        if deadlineInput.isdigit():
            self.deadline = int(deadlineInput)
            self.ConfirmDialog.close()
            self.startup()

    def runtimeSettingsSave(self):
        for i in range(len(self.externalProcessValueList)):
            self.externalProcessValueList[i]["path"] = self.externalProcessesUiList[i]["pathEdit"].text()
            self.externalProcessValueList[i]["cmd"] = self.externalProcessesUiList[i]["cmdEdit"].text()

        self.showInfoDialog("Runtime Environment settings updated!")

    def setProcessPath(self, processNum):
        selectedPath = QFileDialog.getExistingDirectory(
            None,
            "Please Select Path",
        )
        if selectedPath != "":
            self.externalProcessesUiList[processNum]["pathEdit"].setText(selectedPath)

    def runtimeSettingEnable(self, isEnable):
        for i in range(len(self.externalProcessesUiList)):
            self.externalProcessesUiList[i]["pathEdit"].setEnabled(isEnable)
            self.externalProcessesUiList[i]["selBut"].setEnabled(isEnable)
            self.externalProcessesUiList[i]["cmdEdit"].setEnabled(isEnable)
            # if i != 0 and i != 1:
            #     self.externalProcessesUiList[i]["enableBut"].setEnabled(isEnable)
        self.runtimeSaveBut.setEnabled(isEnable)

    def move2Center(self):
        screen = QDesktopWidget().screenGeometry()
        size = self.geometry()
        newLeft = int((screen.width() - size.width()) / 2)
        newTop = int((screen.height() - size.height()) / 2)

        self.move(newLeft, newTop)

    def switchView(self):
        with contextlib.suppress(Exception):
            i = self.sideBar.currentIndex().row()
            self.mainView.setCurrentIndex(i)

    def printLog2Ui(self, text, num):
        runningLogWin = self.runningLogList[num]
        cursor = runningLogWin.textCursor()
        cursor.movePosition(QtGui.QTextCursor.End)
        cursor.insertText(text)
        runningLogWin.setTextCursor(cursor)
        runningLogWin.ensureCursorVisible()

    def showInfoDialog(self, text):
        self.InfoDialogUi.label.setText(text)
        self.InfoDialog.show()

    def emuComplete(self):
        self.stop()
        self.showInfoDialog("Emulation Task completed!")

    def stop(self):
        self.stopBut.setEnabled(False)
        self.startupBut.setEnabled(True)
        self.showWavesBut.setEnabled(True)
        self.runtimeSettingEnable(True)

        self.externalProcesses.killAllProcesses()
        self.timeMonitor.stop()
        self.progressMonitor.stop()

    def startup(self):
        self.startupBut.setEnabled(False)
        self.stopBut.setEnabled(True)
        self.showWavesBut.setEnabled(False)
        self.runtimeSettingEnable(False)
        self.updateTimeLabel("", "", "")
        for i in range(len(self.runningLogList)):
            self.runningLogList[i].clear()

        self.externalProcesses.progressCtrl(0)
        self.progressMonitor.start()
        self.timeMonitor.setDeadline(self.deadline)
        self.timeMonitor.start()

    def showWaves(self):
        self.externalProcesses.progressCtrl(5)

    def updateTimeLabel(self, simTime, wallClock, ratio):
        self.simTimeValue.setText(str(simTime))
        self.wallClockValue.setText(str(wallClock))
        self.timeScaleValue.setText(str(ratio))

    def exit(self):
        self.stop()
        QtCore.QCoreApplication.quit()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    app.setStyleSheet(qdarkstyle.load_stylesheet(qt_api='pyqt5', palette=LightPalette()))
    MainWindow = QMainWindow()
    ui = OEMainwindow()
    ui.setupUi(MainWindow)
    ui.runtimeCfg()
    ui.runtimeInit()
    MainWindow.show()
    sys.exit(app.exec_())
