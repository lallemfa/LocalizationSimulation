init; 
axis([-0.5 3.5 -1.2 2.8]);
axis square; hold on;

load lidar_data A1;
x1=A1(:,1); y1=A1(:,2);
%plot(x1,y1,'oblack'); 

f = getframe;              %Capture screen shot
[im,map] = frame2im(f);    %Return associated image data
imwrite(im,'lidar_data.bmp');
clc;


%% formation des alignements
n=10;   
alpha3=[];d3=[];  % pour stocker les alignements
for i=1:n:length(A1)-n, % on prend les points par groupes de n
    x2=x1(i:i+n-1); y2=y1(i:i+n-1);    
    A2=[x2,y2]; b2=ones(n,1); 
    p2=(A2'*A2)\A2'*b2; d2=1/norm(p2); 
    alpha2=atan2(p2(2),p2(1));
    if (norm(A2*p2-b2)<0.05),  
        plot(x2,y2,'+black','LineWidth',2);
        d3=[d3;d2];alpha3=[alpha3;alpha2];
    end
end  
f = getframe;              %Capture screen shot
[im,map] = frame2im(f);    %Return associated image data
imwrite(im,'lidar_align.bmp');

alpha3m=atan2(median(sin(4*alpha3)),median(cos(4*alpha3)))/4; 
for k=0:3,
  alpha4=k*pi/2+alpha3m; 
  I=cos(alpha3-alpha4)>0.9; 
  d4=median(d3(I));  
  w=d4*[cos(alpha4);sin(alpha4)]*[1,1]+...
       [-sin(alpha4);cos(alpha4)]*[-10,10];  
  plot(w(1,:),w(2,:),'blue','LineWidth',2);
end

f = getframe;              %Capture screen shot
[im,map] = frame2im(f);    %Return associated image data
imwrite(im,'lidar_estime.bmp');
