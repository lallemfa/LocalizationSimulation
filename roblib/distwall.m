init; clear all;
clf; axis([0,16,-2,14]);   axis square; hold on;
A=[2 15  3;   1  5  12];
B=[15  3  2;  5  12  1];
C=[];dbar=[];
for i=1:3,
u=(B(:,i)-A(:,i))/norm(B(:,i)-A(:,i)); 
C=[C;[-u(2),u(1)]];
dbar=[dbar;det([u,-A(:,i)])];
end
d=[2;5;4];
y=d-dbar;
x0=[1;2];G0=100*eye(2,2);u=0*x0;Galpha=0*G0;Gbeta=eye(3,3);
[x1,G1]=kalman(x0,G0,u,y,Galpha,Gbeta,eye(2,2),C)
plot(x1(1),x1(2),'+');
for i=1:3;
plot([A(1,i),B(1,i)],[A(2,i),B(2,i)],'black','LineWidth',2);
draw_circle(x1,d(i),'blue',1);
draw_ellipse(x1,G1,0.9,'black',2);
end






