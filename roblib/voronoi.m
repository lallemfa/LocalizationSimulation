

init; m=50; 
P=10*rand(2,m);
axis([-5,15,-5,15]); axis square; hold on;
plot(P(1,:),P(2,:),'oblack','LineWidth',3);

C=[]; K=[];
for i=1:m-2;
    for j=i+1:m-1
        for k=j+1:m,
            A=P(:,[i,j,k]); % triangle selectionné
            c=[2*A',[-1;-1;-1]]\sum(A.^2,1)';
            r=sqrt(norm(c(1:2))^2-c(3));
            valid=true;
            for q=1:m,
               valid=valid&&(q==i||q==j||q==k||norm(P(:,q)-c(1:2))>r);  
            end  
            if valid
                %draw_circle(c(1:2),r);
                %plot(c(1),c(2),'+blue');
                plot(A(1,[1,2,3,1]),A(2,[1,2,3,1]),'red','LineWidth',1);
                C=[C,c]; K=[K,[i;j;k]];
            end                            
        end
    end
end

for i=1:length(K),
    for j=1:length(K)
      if sum(ismember(K(:,i),K(:,j)))==2,
         plot(C(1,[i,j]),C(2,[i,j]),'green','LineWidth',3);
      end
    end
end

        
        
        
        
        



