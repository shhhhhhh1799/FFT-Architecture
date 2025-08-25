![대한상공회의소](https://img.shields.io/badge/대한상공회의소_서울기술교육센터-003366?style=flat&logo=git&logoColor=1E90FF)
![과정: AI 시스템반도체설계 2기](https://img.shields.io/badge/과정-AI%20시스템반도체설계%202기-FFD700?style=flat&logo=github&logoColor=FFD700)
![과목: Memory Controller SoC Peripheral 설계 프로젝트](https://img.shields.io/badge/과목-Memory%20Controller%20SoC%20Peripheral%20설계%20프로젝트-4CAF50?style=flat&logo=databricks&logoColor=white)

![Verilog](https://img.shields.io/badge/Verilog-HDL-blue?style=flat&logo=verilog&logoColor=white)
![SystemVerilog](https://img.shields.io/badge/SystemVerilog-HDL-00599C?style=flat&logo=verilog&logoColor=white)
![MATLAB](https://img.shields.io/badge/MATLAB-MathWorks-orange?style=flat&logo=MathWorks&logoColor=white)
![Synopsys Verdi](https://img.shields.io/badge/Synopsys-Verdi-663399?style=flat&logoColor=white)
![Xilinx Vivado](https://img.shields.io/badge/Xilinx-Vivado-FCAE1E?style=flat&logo=xilinx&logoColor=white)

## 프로젝트 주제: FFT 설계(7조)
* 프로젝트 진행기간: 25.07.14 ~ 25.08.05
* 구성원: 강석현(팀장), 문우진, 박승헌, 최지우

---

## ⚙️ 사용 도구 및 환경

- Verilog / SystemVerilog
- Vivado (FPGA synthesis)
- Verdi (시뮬레이션 파형 분석)
- MATLAB (결과 비교 및 분석)
- Synopsys VCS (시뮬레이션)
- MobaXterm, GitHub, VS Code

---

## 🎯 프로젝트 목표

> Fixed-point 기반 FFT를 RTL로 구현하고, FPGA에서 검증 가능한 구조로 개발한다.

- 512-point FFT 구조 설계
- Radix-2² 알고리즘 기반 파이프라인 구성
- CBFP(Convergent Block Floating Point) 적용
- MATLAB과 RTL 결과 비교 검증
- FPGA(Vivado) 기반 검증 (Zynq-7000, UltraZed 등)

---

## 📊 결과 요약

- 고정소수점 정확도 확보: <N.bit> 정밀도 구현
- RTL & MATLAB 결과 100% 일치 검증
- 시뮬레이션 파형 검증 완료
- FFT Throughput 개선 및 자원 최적화

---
