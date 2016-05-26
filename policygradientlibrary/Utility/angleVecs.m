function angle = angleVecs(a, b)
% angle = angleVecs(a, b) returns the angle between two vectors a and b. 

	angle = 360/(2*pi)*acos(min((a'*b)/(10^-10+norm(a,2)*norm(b,2)),1));
	