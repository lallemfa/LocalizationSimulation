y=[0.38;3.25;4.97;-0.26];
t=[1;2;3;7];
C=[ones(size(t)),-cos(t)];
pbar=[0;0];
G_p=1000*eye(2,2);
G_Beta=0.01*eye(4,4); 
ytilde=y-C*pbar; 
G_y=C*G_p*C'+G_Beta;
K=G_p*C'*inv(G_y); 
phat=pbar+K*ytilde; G_eps=G_p-K*C*G_p;
t1=0:0.01:20; x1=phat(1)*t1-phat(2)*sin(t1); 
y1=phat(1)-phat(2)*cos(t1); plot(x1,y1);











