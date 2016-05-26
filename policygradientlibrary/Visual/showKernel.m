function showKernel(K, titleCaption)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% showKernel(K, titleCaption) visualizes transition or
% resolvant kernel given as matrix in K.
%
% Related: resolvantKernel, transitionKernel, oneStepTransitionKernel


	global N M
	imagesc(K); 
   title(titleCaption); 
   for x=1:N
      for xx=1:N
         text(xx-0.25, x, ['x=' num2str(x) ',\newlinex\prime=' num2str(xx)]);
      end;
   end;   
   axis off;
