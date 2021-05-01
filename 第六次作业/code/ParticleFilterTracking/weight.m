function w=weight(p,q,sita,m)
simi=0;
for i=1:m;
 simi=simi+(p(i)*q(i))^0.5;  %%其中q是目标模板的颜色直方图，p是以某一中心候选区域的颜色直方图，通过Bhattacharyya系数来衡量她们的相似程度
end
d=(1-simi)^0.5;   %%相应的Bhattacharyya距离，作为该粒子的观测
%根据每一个候选区域与目标区域的相似程度给出权重
w=(1/(sita*(2*pi)^0.5))*exp(-(d^2)/(2*sita^2));   %%p（z/x）=(1/(sita*(2*pi)^0.5))*exp(-(d^2)/(2*sita^2))为该粒子的观测概率，均方差sita通常取为0.2
