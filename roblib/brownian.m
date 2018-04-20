function brownian
    function [T,X,Y]=Simu(delta,sx,tmax)
        T=0:delta:tmax;
        kmax=length(T);
        X=sx*randn(1,kmax);
        Y=0*X;
        for k=1:kmax-1,
            Y(k+1)=Y(k)+delta*X(k);
        end
    end
figure(1); init;
hold on;
axis([0 100 -20 20]);
for i=1:100,
    delta=0.1; %0.01, 0.001
    [T,Y]=Simu(delta,1,100);
    plot(T,Y,'black');
end
figure(2); init; hold on;
for i=1:100,
    delta=1; %0.1 0.01
    [T,X,Y]=Simu(delta,1/sqrt(delta),100);
    plot(T,X,'black');
end
end


