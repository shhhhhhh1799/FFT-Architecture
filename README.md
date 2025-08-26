# ⚡ FFT-Architecture (512-point Fixed-point FFT)

![대한상공회의소](https://img.shields.io/badge/대한상공회의소_서울기술교육센터-003366?style=flat&logo=git&logoColor=1E90FF)
![과정: AI 시스템반도체설계 2기](https://img.shields.io/badge/과정-AI%20시스템반도체설계%202기-FFD700?style=flat&logo=github&logoColor=FFD700)
![과목: Memory Controller SoC Peripheral 설계 프로젝트](https://img.shields.io/badge/과목-Memory%20Controller%20SoC%20Peripheral%20설계%20프로젝트-4CAF50?style=flat&logo=databricks&logoColor=white)

![Verilog](https://img.shields.io/badge/Verilog-HDL-blue?style=flat&logo=verilog&logoColor=white)
![SystemVerilog](https://img.shields.io/badge/SystemVerilog-HDL-00599C?style=flat&logo=verilog&logoColor=white)
![MATLAB](https://img.shields.io/badge/MATLAB-MathWorks-orange?style=flat&logo=MathWorks&logoColor=white)
![Synopsys Verdi](https://img.shields.io/badge/Synopsys-Verdi-663399?style=flat&logoColor=white)
![Xilinx Vivado](https://img.shields.io/badge/Xilinx-Vivado-FCAE1E?style=flat&logo=xilinx&logoColor=white)

---

## 👥 프로젝트 정보
- **프로젝트 주제**: FFT 설계 (7조)  
- **진행 기간**: 2025.07.14 ~ 2025.08.05  
- **팀원**: 강석현(팀장), 문우진, 박승헌, 최지우  

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
- CBFP (Convergent Block Floating Point) 적용  
- MATLAB과 RTL 결과 비교 검증  
- FPGA(Vivado) 기반 검증 (Zynq-7000, UltraZed 등)  

---

## 📌 설계 개요
본 프로젝트는 **512-point FFT(Fast Fourier Transform)** 를  
**Fixed-point 연산 기반**으로 설계 및 검증한 프로젝트입니다.  

Floating-point 연산 대비 연산 자원을 절약하면서도, **SQNR(신호 대 잡음비)**를 확보할 수 있도록  
Saturation, Truncation, CBFP(Common Block Floating Point) 정규화를 포함한 구조를 적용했습니다.  

---

## 📊 설계 구조

### 📐 FFT 파이프라인 개요
FFT는 Radix-2² 기반으로 구현되었으며, 각 단계는 Butterfly 연산과 Twiddle Factor 곱을 포함합니다.  
CBFP를 통해 연산 정밀도를 유지하면서도 자원 소모를 최적화했습니다.  

<p align="center">
  <img src="https://github.com/shhhhhhh1799/Image/blob/main/FFT%20Process.png" alt="FFT Process" width="800"/>
</p>

---

### 🔢 Fixed Coefficient

FFT 연산 과정에서 **고정소수점(Fixed-point) 연산**을 적용하며,  
각 단계별 정수부/소수부 비트 폭을 조정하여 **오버플로 방지** 및 **정밀도 유지**를 수행했습니다.  

- ● 정수부: **saturation (포화 연산)**  
- ● 소수부: **truncation (절삭 연산)**  

<p align="center">
  <img src="https://github.com/shhhhhhh1799/Image/blob/main/Fixed%20Coefficient.png" alt="Fixed Coefficient" width="800"/>
</p>

---

## 🏗️ 모듈 구조

### 🔹 Module 0
- 입력: `<9 bit>` → 출력: `<11 bit>`  
- 덧셈/뺄셈 → 비트 확장 (9 → 10 → 11 bit)  
- Twiddle 곱: 21 bit → Truncation (13 bit)  
- CBFP 정규화 후 최종 11 bit 출력  

### 🔹 Module 1
- 입력: `<11 bit>` → 출력: `<12 bit>`  
- 덧셈/뺄셈: 11 → 12 → 13 bit 확장  
- Twiddle 곱: 22 bit → Truncation (14 bit)  
- CBFP 정규화 후 12 bit 출력  

### 🔹 Module 2
- 입력: `<12 bit>` → 출력: `<13 bit>`  
- 덧셈/뺄셈: 12 → 13 → 14 bit 확장  
- Twiddle 곱: 23 bit → Truncation (15 bit)  
- CBFP 정규화 후 최종 13 bit 출력  

---

## 🏗️ FFT Architecture

아래 그림은 512-point FFT의 전체 RTL Architecture를 나타낸 것입니다.  
Module 0 → Module 1 → Module 2 순으로 파이프라인 구조가 이어지며,  
각 모듈은 Butterfly(ADD/SUB)와 Twiddle Factor 연산을 포함하고, 마지막에 **Bit Reorder**를 수행합니다.  

<p align="center">
  <img src="https://github.com/shhhhhhh1799/Image/blob/main/FFT%20Architecture.png" alt="FFT Architecture" width="850"/>
</p>

---

## 📊 결과 분석 (SQNR)

FFT 성능을 평가하기 위해 **CBFP 적용 유무에 따른 SQNR (Signal-to-Quantization-Noise Ratio)** 를 측정했습니다.  
**입력 데이터 타입**은 `Random`과 `Cosine` 두 가지 경우로 나누어 비교했습니다.

<p align="center">
  <img src="https://github.com/shhhhhhh1799/Image/blob/main/SQNR.png" alt="SQNR with vs without CBFP" width="750"/>
</p>

### 📈 분석
- CBFP를 적용하지 않은 경우, Random 입력 데이터에서는 **SQNR이 7.24 dB**로 급격히 저하됨 → **연산 과정에서 비트 폭 손실 심각**  
- CBFP 적용 시, Random 입력 데이터에서도 **41 dB 이상**으로 유지 → **정규화 덕분에 안정적인 성능 확보**  
- Cosine 입력 데이터는 주파수 성분이 제한적이라 CBFP 적용 유무와 무관하게 약 **40 dB 수준**의 성능을 유지  

➡️ **CBFP는 다양한 입력 신호 환경에서 SQNR을 안정적으로 유지하는 데 필수적임**을 확인할 수 있습니다.  

---

### 📈 분석
- CBFP를 적용하지 않은 경우, Random 입력 데이터에서는 **SQNR이 7.24 dB**로 급격히 저하됨 → **연산 과정에서 비트 폭 손실 심각**  
- CBFP 적용 시, Random 입력 데이터에서도 **41 dB 이상**으로 유지 → **정규화 덕분에 안정적인 성능 확보**  
- Cosine 입력 데이터는 주파수 성분이 제한적이라 CBFP 적용 유무와 무관하게 약 **40 dB 수준**의 성능을 유지  

➡️ **CBFP는 다양한 입력 신호 환경에서 SQNR을 안정적으로 유지하는 데 필수적임**을 확인할 수 있습니다.  

---

## 📂 파일 구성 (예시)
```plaintext
FFT-Architecture/
├── module0/          # Module 0 (9 → 11bit 변환)
├── module1/          # Module 1 (11 → 12bit 변환)
├── module2/          # Module 2 (12 → 13bit 변환)
├── cbfp/             # CBFP 정규화 모듈
├── sim/              # Testbench 및 시뮬레이션 결과
└── docs/             # 설계 문서 및 분석 자료
