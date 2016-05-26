%% 
function SortCompare()

NUM = 20000;
div = 20;

tiConsu(2,div) = 0;
j = 1;
    for i = 1 : NUM/div : NUM
        data1 = randi(9999,1 ,i);
        data2 = data1;
        t1 = clock;
        data1 = myInPlaceQuickSort(data1 ,1, i );
        t2 = clock;
        tiConsu(1,j) = etime( t2 , t1 );

        t1 = clock;
        data2 = myInsertSort( data2 );
        t2 = clock;
        tiConsu(2,j) = etime( t2 , t1 );
        j = j + 1
    end
    plot(tiConsu');
end

%%
function data = myInPlaceQuickSort( data, a , b )

    if ( a >= b )
			return ;
    end
		pivot = data(b);
		l = a ;
        r = b - 1 ;
		while ( l <= r )
			while ( l <= r && data(l) <= pivot )
				l = l + 1;
            end
			while ( l <= r && data(r) >= pivot )
				r = r - 1 ;
            end
			if ( l < r )
				temp = data(l);
				data(l) = data(r);
				data(r) = temp;
            end
        end
		temp = data(l);
		data(l) = data(b);
		data(b) = temp;
		data = myInPlaceQuickSort( data , a , l - 1 );
		data = myInPlaceQuickSort( data , l + 1 , b );
end

%%
function data = myInsertSort ( data )
    n = length(data);
    for i = 1 : n
        temp = data(i);
		j = i;
		while ( j > 1 && data(j - 1 ) > temp )
            data(j) = data(j-1);
            j = j - 1 ;
        end
			data(j) = temp;
    end
    
end