function dif = lengthDifference(a, b)
% dif = lengthDifference(a, b) computes the difference in length of vectors a and b.

	dif = norm(a,2) - norm(b,2);
	