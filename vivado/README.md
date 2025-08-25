# FPGA Guide
## A. Xilinx Vivado Start
1. Xilinx Vivado를 시작하여 'Create Project' 실행.
2. Project를 만드는 과정에서 사전에 배치한 보드(Avnet-Tria UltraZed-7EV Carrier Card)를 선택.
(+ 단, 해당 보드가 선택지에 없다면, 상위의 디렉토리에서 `\fpga_board` 디렉토리 내부에 있는 README.md을 읽고 올 것)
3. 생성된 Project에 대하여, 해당 디렉토리에 위치한 3개의 디렉토리 내부의 코드를 모두 'Add Source' 진행.
(+ ADD Source 중에 `src` 폴더에 있는 `(.mem)` 파일 2개도 같이 `design source` 로 추가할 것!  )

## B. VIO setting
1. 좌측의 `IP Catalog`를 누른 뒤, Search에서 `VIO(Virtual Input/Output)`을 선택.
2. `Input Probe Count`에 `33` 기입.
3. 이후에 생성된 `PROBE_IN_Porst`에 대하여, 첫 번째를 제외하고 모두 `13` 기입.(PROBE_IN0의 값은 1로 유지.)
4. `PROBE_OUT Ports`에 대하여, `Initial Value`의 값을 `0x1` 기입. 

## C. Clock / Frequency setting
1. 좌측의 `IP Catalog`를 누른 뒤, Search에서 `Clocking Wizard`을 선택.
2. `Clocking Options`에서 `clk_in1`에 대하여, `Input Frequency(MHz)`의 값에 `300.000`을 기입하고, `Source`의 값을 `Differential clock capable pin`으로 변경.
3. `Output Clocks`에서 `Enable Optional Inputs/Outputs for MMCM/PLL`의 선택지 중에서 `reset`만 남기고 모두 해제(`locked`만 해제하면 될 것.)하고, `Reset Type`을 `Active Low`로 설정.

## D. ERROR Issue
1. 이후에 simulation을 진행하는 과정에서 `reorder.sv`에 대하여 error가 확인되는데, 이를 무시하고 다시 simulation을 진행하면 문제없이 파형이 확인됨.
