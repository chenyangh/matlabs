function showDiscountedDistribution(data, colour1, colour2)

	global N problemType gamma
   
   if(nargin<3)
      colour1 = 'b';
      colour2 = 'r';
   end;   
   
   policy = data(1).policy;   
   
   if(problemType==1)   	
      nTrials = max(size(data));
      for trials=1:nTrials
         x(:,trials) = data(trials).x';
      end;   
      
      hh = zeros(N,1);
      for steps=1:max(size(data(1).x))
         [h,p]=hist(x(steps, :),1:N);
         hh = hh + (1-gamma)*(gamma^(steps-1))*h';
      end;         
      
      hh=hh/sum(hh);
      
      handle=bar(p,hh, 0.5, 'r');
      set(handle, 'FaceLighting', 'none');
      set(handle, 'FaceColor', 'none');
      set(handle, 'EdgeColor', colour1);

		dstat = discountedDistribution(policy);
      handle=bar(p,dstat, 0.5, 'r');
      set(handle, 'FaceLighting', 'none');
      set(handle, 'FaceColor', 'none');
      set(handle, 'EdgeColor', colour2);                  
   elseif(problemType==2 & N==1)
      nBins = 35;
      
      global backupPolicy
      stationaryDistribution(policy, data(1).x(1));
            
      L = max(size(data(1).x));
		H = max(size(data));      
      for steps=1:L         
         for traj=1:H
            x(steps, traj) = data(traj).x(steps);
         end;   
      end;
            
      maxx = max(max(x))+backupPolicy.S;  
      minn = min(min(x))-backupPolicy.S;       
      bins = linspace(minn,maxx,nBins);      
      
      hh = zeros(N,1);
      for steps=1:L         
         [h,p]=hist(x(steps, :),bins);
         h=nBins/(2*abs(maxx))*h/sum(h);         
         hh = hh + (1-gamma)*(gamma^(steps-1))*h';
      end;               
      
      handle=bar(p,hh, 0.5, colour1);
      set(handle, 'FaceLighting', 'none');
      set(handle, 'FaceColor', 'none');
      set(handle, 'EdgeColor', colour1);                        
      
      for i=1:max(size(bins));
         stat(i)=discountedDistribution(policy, bins(i));
      end;
      plot(p, stat, colour2);
   elseif(problemType==2 & N==2)		            
      L = max(size(data(1).x));
		H = max(size(data));      
      for steps=1:L         
         for traj=1:H
            reorder(steps).x(:, traj) = data(traj).x(:,steps);
         end;   
      end;                  
   	x = []; 
		for trials=1:max(size(data))
   		x = [x data(trials).x];
   	end;   
      
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
      hh = zeros(nBins-1, nBins-1);
      for steps=1:L
         h=hist2d(reorder(steps).x(:, :)', binsEdge1, binsEdge2);
         h=(nBins^2)*h/(sum(sum(h))*sqrt(Area)); 
         
      	hh = hh + (1-gamma)*(gamma^(steps-1))*h;
      end;                           
      
	   % ANALYTICAL STATIONARY DISTRIBUTION            
      for i=1:(nBins-1);
         for j=1:(nBins-1);
            stat(i,j)=discountedDistribution(policy, [bins1(i) bins2(j)]');
         end;   
      end;
      
      hold on;             
      
      hts = sort(hh(find(hh>0)));
		hts=hts(round(linspace(1,max(size(hts)),4)));

		[n,m]=size(stat);

		hold on;
		pcolor(binsEdge1(1:(nBins-1)), binsEdge2(1:(nBins-1)),hh');
		contour(bins1, bins2,stat',hts,'r');
		axis([min(x(1,:)) max(x(1,:)) min(x(2,:)) max(x(2,:))]);
      colorbar;      
      
      % PLOT WAY OF THE MEANS THROUGH SPACE
      clear x;
      global my0 A b
      k = policy.theta.k;
      x(:,1) = my0;
		for t=1:10
		   x(:,t+1) = (A+b*k')*x(:,t);
		end;   
		plot(x(1,:),x(2,:),'g-');
		plot(x(1,:),x(2,:),'g*');      
   else
      disp('ERROR: I cannot plot this data. Possible causes: neither discrete nor 1 to 2d LQR problem');
   end;   