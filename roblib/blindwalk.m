xhat=[0;1];
Gx=diag([0,0.02^2]);
Galpha=diag([0,0.01^2]);
draw_ellipse(xhat,Gx,0.9,'red',3); hold on;
ex1=zeros(20,1);
deter=zeros(20,1);
for k=0:19,
    if (k<10) u=1; else u=-1; end;
    Ak=[1 u;0 1];
    [xhat,Gx]=kalman(xhat,Gx,0,[],Galpha,[],Ak,[]);    
    draw_ellipse(xhat,Gx,0.99,'blue',1);
    ex1(k+1)=sqrt(Gx(1,1));
    deter(k+1)=det(Gx);
end
figure(2);
plot(ex1,'red');
figure(3);
plot(deter,'green');