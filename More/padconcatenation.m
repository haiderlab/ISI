function [catmat]=padconcatenation(a,b)
sa=size(a);
sb=size(b);
lm = sa(3) + sb(3);
tempmat=NaN(sa(1)+sb(1),max([sa(2) sb(2)]));
tempmat(1:sa(1),1:sa(2),1:sa(3))=a;
tempmat(1:sb(1), 1:sb(2),sa(3)+1:lm)=b;

catmat=tempmat;
end
