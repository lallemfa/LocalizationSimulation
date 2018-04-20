Galpha=zeros(2,2);
A=eye(2,2);
C0=[2,3]; C1=[3,2]; C2=[1,-1]; u=0; 
xhat0=[0;0]; Gx0=1000*eye(2,2);
draw_ellipse(xhat0,Gx0,0.9,'red',2);
hold on;
[xhat1,Gx1]=kalman(xhat0,Gx0,u,8,Galpha,1,A,C0);
draw_ellipse(xhat1,Gx1,0.9,'magenta',2);
[xhat2,Gx2]=kalman(xhat1,Gx1,u,7,Galpha,4,A,C1);
draw_ellipse(xhat2,Gx2,0.9,'green',2);
[xhat3,Gx3]=kalman(xhat2,Gx2,u,0,Galpha,4,A,C2);
draw_ellipse(xhat3,Gx3,0.9,'blue',4);

y=[8;7;0]; Gbeta=diag([1 4 4]);
C=[C0;C1;C2];
[xhat,Gx]=kalman(xhat0,Gx0,u,y,Galpha,Gbeta,A,C);
draw_ellipse(xhat,Gx,0.9,'red',1);




