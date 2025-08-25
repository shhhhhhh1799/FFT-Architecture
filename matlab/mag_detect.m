% Added on 2024/01/29 by jihan 
%% 해설 : - fixed point에 대하여, 2의 보수 표현 값의 유효 비트를 파악하기 위하여 사용.
%%        - 상위 bit에서 연속되는 '부호 확장 비트(sign extension bit)'가 몇개인지 세어서, 
%%          정규화 또는 쉬프팅을 위한 shift count의 값(cnt)을 반환.

function [cnt] = mag_detect(in_dat, num) 

  n=0;

  out_dat=dec_to_bin(in_dat, num);

  % 양수일 경우, MSB 쪽의 0의 bit 수를 센다.
  if (out_dat(num)==0) 
   for i=1:num-1
    if (out_dat(num-i)==0) 
	n=n+1;
    else
	break
    end	
   end
  % 음수일 경우, MSB 쪽의 1의 bit 수를 센다.
  else
   for i=1:num-1
    if (out_dat(num-i)==1) 
	n=n+1;
    else
	break
    end
   end
  end

  cnt=n;

end
