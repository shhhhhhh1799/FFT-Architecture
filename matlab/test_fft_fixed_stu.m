% FFT 테스트
clc;
clear;

% === 1. 입력 데이터 로딩 ===
i_data = load('.\text_files\cos_i_dat.txt');
q_data = load('.\text_files\cos_q_dat.txt');
din = complex(i_data, q_data);  % <2.7> 형식 입력

% === 2. FFT 수행 ===
[fft_out, module2_out] = fft_fixed_stu(1, din);  % fft_mode = 1 (FFT)

% === 3. 전체 결과 텍스트 파일로 저장 ===
fid = fopen('.\outputs\fft_out_result.txt', 'w');
fprintf(fid, 'Index\tReal\tImag\tMagnitude\n');
for k = 1:length(fft_out)
    fprintf(fid, '%d\t%d\t%d\t%f\n', ...
        k, real(fft_out(k)), imag(fft_out(k)), abs(fft_out(k)));
end
fclose(fid);
