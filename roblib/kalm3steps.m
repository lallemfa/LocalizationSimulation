% x=randn(1,10000);
% for i=1:500,
% x=x(1:length(x)-1)+x(2:length(x));
% end;
% figure(1);plot(x,'+');
% a=x(1:9000); b=x(2:9001);
% figure(2);plot(a,b,'+red')

A0=[0.5 0;0 1]; A1=[1 -1;1 1]; A2=A1;
u0=[8;16]; u1=[-6;-18]; u2 =[32;-8];
C0=[1 1]; C1=[1 1]; C2=[1 1];
y0=7; y1=30; y2=-6;
Galpha=eye(2,2);
Gbeta=1;
xhat0=[0;0]; Gx0=100*eye(2,2);
draw_ellipse(xhat0,Gx0,0.8,'black',3); hold on;
[xhat1,Gx1,xup0,Gup0]=kalman(xhat0,Gx0,u0,y0,Galpha,Gbeta,A0,C0);
draw_ellipse(xup0,Gup0,0.9,'black',1); 
draw_ellipse(xhat1,Gx1,0.9,'red',2)
[xhat2,Gx2,xup1,Gup1]=kalman(xhat1,Gx1,u1,y1,Galpha,Gbeta,A1,C1);
draw_ellipse(xup1,Gup1,0.9,'red',1); 
draw_ellipse(xhat2,Gx2,0.9,'green',2)
[xhat3,Gx3,xup2,Gup2]=kalman(xhat2,Gx2,u2,y2,Galpha,Gbeta,A2,C2);
draw_ellipse(xup2,Gup2,0.9,'green',1); 
draw_ellipse(xhat3,Gx3,0.9,'magenta',2)



