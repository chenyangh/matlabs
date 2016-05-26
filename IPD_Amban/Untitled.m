minVal = min(temp);
maxVal = max(temp);
freq = [];
intervalVal = 10000;
freq(end+1) = sum( temp < 20000 );
freq(end+1) = sum( temp >= 20000 & temp < 100000) ;
freq(end+1) = sum( temp >= 100000 & temp < 500000) ;

freq( freq == 0 ) = [];

