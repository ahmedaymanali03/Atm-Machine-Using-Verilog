vlib work
vlog MainModule.v Test-tb.v +cover 
vsim -voptargs=+acc work.ATM_Tbbbb -cover
add wave *
coverage save Test-tb.ucdb -onexit -du ATM
run -all
