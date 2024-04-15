ch?=4
xbar?=true

all: hbm qsys

hbm: hbm_ss.tcl
	qsys-script --cmd="set hbm_channels $(ch); set en_xbar $(xbar)" --script=hbm_ss.tcl

qsys: hbm_ss.qsys
	qsys-generate --synthesis=VERILOG -qpf=hbm_ss -c=hbm_ss hbm_ss.qsys

clean:
	rm -fr *qpf *qsf *qsys *qsys.legacy .qsys_edit/ hbm_ss/ ip/ *~ qdb/ dni/ board.info
