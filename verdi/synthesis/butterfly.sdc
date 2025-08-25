#-----------------------------------------------------------------------
#  Clock Frequency and Margin Definition
#-----------------------------------------------------------------------

set per500   "2000.0"      ;# ps → 500 MHz
set CLK_MGN  0.7        ;# 30% margin
set io_dly   0.05       ;# 5% I/O delay

# 실제 synthesis 타겟 주기: 2.0ns * 0.8 = 1.4ns → 714 MHz
set cnt_clk_period    [expr {$per500 * $CLK_MGN}]          ;# 1.6 ns
set cnt_clk_period_h  [expr {$cnt_clk_period / 2.0}]       ;# 0.8 ns

set cnt_clk_delay     [expr {$cnt_clk_period * $io_dly}]   ;# 0.08 ns

#-----------------------------------------------------------------------
#  Create Clock
#-----------------------------------------------------------------------

create_clock -name cnt_clk \
             -period $cnt_clk_period \
             -waveform "0 $cnt_clk_period_h" \
             [get_ports clk]

#-----------------------------------------------------------------------
#  Clock Uncertainty
#-----------------------------------------------------------------------

# 10% of clock period 정도로 설정하는 것이 일반적
# 여기서는 setup/hold 각 0.1 ns 설정
#set_clock_uncertainty -setup 0.1 [all_clocks]
set_clock_uncertainty -setup 50 [all_clocks] 
set_clock_uncertainty -hold  0.1 [all_clocks]

#-----------------------------------------------------------------------
#  Output/Input Delay
#-----------------------------------------------------------------------

# input/output delay는 일반적으로 외부 I/O 환경에 맞게 설정
# 여기서는 간단히 clk 기준 상대 지연으로 설정 (예: testbench와 연동)

set_input_delay  $cnt_clk_delay -clock cnt_clk [all_inputs]
set_output_delay $cnt_clk_delay -clock cnt_clk [all_outputs]

#-----------------------------------------------------------------------
#  Design Constraints
#-----------------------------------------------------------------------

# 출력을 가정 부하 설정 (default: 0.2 pf)
set_load 0.2 [all_outputs]

# 타이밍 경로 전이 시간 제한
set_max_transition 0.3 [current_design]
set_max_transition 0.15 -clock_path [all_clocks]

# 팬아웃 제한
set_max_fanout 64 [current_design]

