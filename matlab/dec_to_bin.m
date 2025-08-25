% Added on 2024/01/29 by jihan 
%% 부호 있는 정수를 이진수로 변환.
function [out_dat] = dec_to_bin(in_dat, num) 

  %% 입력이 양수 또는 0인 경우 : 2로 나눈 나머지를 순서대로 저장.
  if (in_dat>=0) 
   for i=1:num
	out_dat(i)=mod(in_dat,2);
	in_dat=floor(in_dat/2);
   end

  %% 입력이 음수인 경우 : 입력의 2에 대하여, 2의 보수 처리를 한 뒤, 2진수를 저장.
  else
	in_dat=(-in_dat)-1;
   for i=1:num
	out_dat(i)=mod(in_dat,2);
	out_dat(i)=xor(out_dat(i),1);
	in_dat=floor(in_dat/2);
   end
  end

end
