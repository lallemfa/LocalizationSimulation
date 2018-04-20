clc;
pv=[sqrt(2);-1;1];
t=[-3;-1;0;2;3;6];
yv=pv(1)*t.^2+pv(2)*t+pv(3);
y=round(yv);
M=[9 -3 1;1 -1 1; 0 0 1; 4 2 1; 9 3 1;36 6 1];
phat=inv(M'*M)*M'*y;
yhat=M*phat;
plot(t,y,'+ black');
hold on;
plot(t,yhat,'+ green');
r=yhat-y;% residus
t=-3:0.1:6;
yv=pv(1)*t.^2+pv(2)*t+pv(3);
plot(t,yv,'red');



