function [ sum ] = testForGlobal(  )
%TESTFORGLOBAL Summary of this function goes here
%   Detailed explanation goes here
global randMat;
sum = 0;
    for i = 1 : 1000
       sum = sum + fightWithTFT( randMat(i,:) );
    end


end

