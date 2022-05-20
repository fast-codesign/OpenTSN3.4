.PHONY: path com cov clean debug verdi sim

PWD_PATH=$(shell pwd)
export CODE_DIR=$(PWD_PATH)/../../src/ASIC_CODE/

CODE_PATH=$(warning SET CODE PATH : $(CODE_DIR))
path: 
	$(CODE_PATH)
    


#verdi ccore
#verdi virtual machine
#VERDI_HOME = /opt/synopsys/Verdi3_L-2016.06-1/
#verdi server
#VERDI_HOME = /disk/Synopsys/Verdi3_vL-2016.06-1/
#verdi ccore
#VERDI_HOME = /edatools/Synopsys/Verdi3_vL-2016.06-1

VERDI_LIB = $(VERDI_HOME)/share/PLI/VCS/linux64/novas.tab  $(VERDI_HOME)/share/PLI/VCS/linux64/pli.a
VERDI_FILE = wave.fsdb
FILE_LIST = ./file_list.f
TOP_MODULE = top_module
export TOP_MODULE 
Date_value=$(shell date "+%Y%m%d%H%M" )
tc_index=1
OUTPUT = simv_$(tc_index)
ALL_DEFINE = +define+ASIC+define+DUMP_FSDB
#########add commad in tb.v#############
#`ifdef DUMP_FSDB
#initial begin
#  $fsdbDumpfile("wave.fsdb");
#  $fsdbDumpvars(0,NS_tb);
#end
#`endif
#########################################
# Code coverage command
CM = -cm line+cond+fsm+branch+tgl 
CM_NAME = -cm_name $(OUTPUT)
CM_DIR = -cm_dir ./$(OUTPUT).vdb

# VPD FILR NAME
VPD_NAME = +vpdfile+$(OUTPUT).vpd

# gate level simualtion without sdf
COM += +nospecify	
COM += +notimingcheck

# gate level simualtion with sdf
#COM_SDF += +define+SDF_ANNOTATION_FF_0P99125C
#COM_SDF += -negdelay 
#COM_SDF += +neg_tchk
#COM_SDF += +sdfverbose
#COM_SDF += -sdfretain
#COM_SDF += +optconfigfile+../TB/no_timing

# compile command
VCS = vcs -j4 -full64 -sverilog +v2k   -diag timescale \
	+lint=TFIPC-L                                   \
	-P $(VERDI_LIB) -debug_access+all               \
	-simprofile                                     \
	-debug_acc+all -debug_region+cell+encrypt		\
	+vcs+flush+all									\
	$(CM)                                           \
	$(ALL_DEFINE)                                   \
	$(VPD_NAME)                                     \
	-o $(OUTPUT)									\
	-l compile_$(tc_index).log					


# simulation command
SIM = ./$(OUTPUT)					\
	$(CM) $(CM_NAME) $(CM_DIR)		\
	$(VPD_NAME)						\
	-l $(OUTPUT).log
# start complie
com:
	$(VCS) -f $(FILE_LIST) $(COM)

com_sdf:
	$(VCS) -f $(FILE_LIST) $(COM_SDF)

# coverage report
report:
	urg -dir ./*.vdb -report cov_report

#start simulation
sim:
	echo TOP_MODULE; $(SIM) -ucli -i ./pre_cmd 
#show fsdb 
verdi:
	$(VERDI_HOME)/bin/verdi -sverilog +v2k -f $(FILE_LIST) -ssf $(VERDI_FILE) -top $(TOP_MODULE) &
#show the cov
cov:
	dve -full64 -covdir *.vdb &
     
debug: 
	dve -full64 -vpd $(OUTPUT).vpd &
# start clean
clean:
	rm -rf ./csrc *.daidir ./csrc *.log *.prof *.vpd *.vdb simv* *.key *race.out* *profileReport* *simprofile_dir* urgReport DVEfiles *~
