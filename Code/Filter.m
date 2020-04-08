%SP16-BCS-041 | SP16-BCS-017 | SP16-BCS-009

function y=Filter(x)
i=ceil(size(x)/2);
if x(i,i)==0;
    y=0;
else
    y=sum(x(:)) - 1;
end