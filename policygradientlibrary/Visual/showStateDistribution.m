function showStateDistribution(data, colour1, colour2)

	global N problemType
   
   if(nargin<3)
      colour1 = 'b';
      colour2 = 'r';
   end;   
   
   x = []; 
	for trials=1:max(size(data))
   	x = [x data(trials).x];
   end;   
   
   policy = data(1).policy;

	if(problemType==1)
      [h,p]=hist(x, 1:N);
      h=h/sum(h);
      handle=bar(p,h, 0.5, 'r');hold on;
      set(handle, 'FaceLighting', 'none');
      set(handle, 'FaceColor', 'none');
      set(handle, 'EdgeColor', colour1);
      
		dstat = stationaryDistribution(policy);
      handle=bar(p,dstat, 0.5, 'r');
      set(handle, 'FaceLighting', 'none');
      set(handle, 'FaceColor', 'none');
      set(handle, 'EdgeColor', colour2);            
   elseif(problemType==2 & N==1)
      nBins = 25;
      
      global backupPolicy
      stationaryDistribution(policy, x(1));
      maxx = max(x)+backupPolicy.S;  
      minn = min(x)-backupPolicy.S;        
      
      [h,p]=hist(x, linspace(minn,maxx,nBins ));
      h=nBins/(abs(maxx-minn))*h/sum(h);
      handle=bar(p,h, 0.5, colour1);
      set(handle, 'FaceLighting', 'none');
      set(handle, 'FaceColor', 'none');
      set(handle, 'EdgeColor', colour1);                  
      
      for i=1:max(size(p));
         stat(i)=stationaryDistribution(policy, p(i));
      end;
      plot(p, stat, colour2);
   elseif(problemType==2 & N==2)
      nBins = 40;
      
      maxx1 = max(x(1,:))+abs(max(x(1,:)))*0.2;  
      minn1 = min(x(1,:))-abs(min(x(1,:)))*0.2;
      maxx2 = max(x(2,:))+abs(max(x(2,:)))*0.2;  
      minn2 = min(x(2,:))-abs(min(x(2,:)))*0.2;  
      
      % EMPIRICAL STATIONARY DISTRIBUTION      
      
      Area  = (maxx1-minn1)*(maxx2-minn2);
      
      binsEdge1 = linspace(minn1,maxx1,nBins);
      binsEdge2 = linspace(minn2,maxx2,nBins);
		bins1 = 0.5*(binsEdge1(1:(nBins-1))+binsEdge1(2:nBins)); 
		bins2 = 0.5*(binsEdge2(1:(nBins-1))+binsEdge2(2:nBins)); 
      
      h=hist2d(x', binsEdge1, binsEdge2);
      h=(nBins^2)*h/(sum(sum(h))*sqrt(Area)); 
      
	   % ANALYTICAL STATIONARY DISTRIBUTION            
      for i=1:(nBins-1);
         for j=1:(nBins-1);
            stat(i,j)=stationaryDistribution(policy, [bins1(i) bins2(j)]');
         end;   
      end;
      
      hold on;             
      
      hts = sort(h(find(h>0)));
		hts=hts(round(linspace(1,max(size(hts)),6)));

		[n,m]=size(stat);

		hold on;
		pcolor(binsEdge1(1:(nBins-1)), binsEdge2(1:(nBins-1)),h');
		contour(bins1, bins2,stat',hts,'r');
		axis([min(x(1,:)) max(x(1,:)) min(x(2,:)) max(x(2,:))]);
		colorbar; 
      
      disp('Data Mean Vector:')
      meanVec = mean(x')'
      disp('Data Covariance Matrix:');
      covMat=cov(x')'
      
      [p,S,my]=stationaryDistribution(policy, [bins2(i) bins1(j)]');
      plot(my(1),my(2),'g*')
      disp('Analytical Mean Vector:');
      my      
      disp('Analytical Covariance Matrix:');
      S
      
   else
      disp('ERROR: I cannot plot this data. Possible causes: neither discrete nor 1 to 2d LQR problem');
   end;   