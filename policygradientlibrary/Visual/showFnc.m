function showFnc(Q, titleCaption)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% showFnc(Q, titleCaption) visualizes an state-action value 
% or advantage function given as matrix in Q.
%
% Related: QFnc, AFnc	

	global N M
	imagesc(Q); 
   title(titleCaption); 
   for x=1:N
      for u=1:M
         text(u-0.25, x, ['x=' num2str(x) ',\newlineu=' num2str(u)]);
      end;
   end;   
   axis off;
