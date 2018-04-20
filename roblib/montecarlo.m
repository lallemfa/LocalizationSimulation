init;
y=[0;1;2.5;4.1;5.8;7.5]; % y(0),...y(5) 
axis([0,2,0,2]); axis('square'); hold on;       
    
for i=1:500, 
    a=2*rand(1); b=2*rand(1); x=[0;0]; 
    A=[1 0;a 0.3];B=[b;1-b];C=[1 1]; 
    ym=0*y; 
    for k=1:6, ym(k)=C*x; x=A*x+B; end 
    if norm(ym-y,inf)<0.3,
               plot(a,b,'+red','linewidth',3);
    else plot(a,b,'.blue');
    end;   
    drawnow();
end
a=0:0.01:2;
b=1.2./(a+0.7);
plot(a,b,'black','linewidth',3)
     
        
