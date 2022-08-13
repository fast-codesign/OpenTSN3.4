###
 # @Date: 2022-06-02 21:12:58
 # @LastEditTime: 2022-06-11 19:56:21
 # @Description: file content
### 
pyinstaller -F -n OpenEmulator main.py -p ./src/InfoDialog.py -p ./src/Dialogwindow.py  -p ./src/EmittingStr.py -p ./src/Mainwindow.py -p ./src/ProgressMonitor.py -p ./src/PathCheck.py -p ./src/Processes.py -p ./src/tool.py -p ./src/TimeMonitor.py --distpath=./

rm -rf ./build ./OpenEmulator.spec 