vlib work
vlog MainModule.v Test-tb.v +cover 
vsim -voptargs=+acc work.Test-tb -cover
add wave *
coverage save Test-tb.ucdb -onexit
run -all