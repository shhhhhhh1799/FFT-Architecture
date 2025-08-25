% Added on 2024/01/29 by jihan 
%% cnt 값에 대하여, 최소의 값을 찾아 누적하는 용도.
function [min_val] = min_detect(index, cnt, temp) 

  if (index==1)     % 당연하게도, 첫 번째 값이 들어갈 때는 그 값이 그대로 출력.
	min_val=cnt;
  else              % 두 번째 부터는 다르게 적용.
    if (temp>cnt) 
	min_val=cnt;
    else    %(temp <= cnt)
	min_val=temp;	
    end
  end

end
