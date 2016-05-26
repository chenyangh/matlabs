function towers_of_hanoi(n,A,B,C)
    if (n~=0)
        towers_of_hanoi(n-1,A,C,B);
        disp(sprintf('Move disk %d from tower %c to tower %c',[n A C]));
        towers_of_hanoi(n-1,B,A,C);
    end
end