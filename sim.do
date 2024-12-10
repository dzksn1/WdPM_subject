vlog -sv cpu_tb.sv
vsim cpu_tb
vsim -voptargs="+acc" cpu_tb
run -all
