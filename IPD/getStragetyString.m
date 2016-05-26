function strategyStr = getStragetyString( posOfStrategy )
%PRINTIPD Print visualized result of a specific strategy
%   Argument aStratety is the one to be printed out



if ( posOfStrategy == 1 ) % fist round
    strategyStr = 'NULL';
elseif ( posOfStrategy <= 5 ) 
    val = 5 - posOfStrategy;
    strategyStr = getStr(val);
elseif ( posOfStrategy <= 21 )
    val = dec2base(21 - posOfStrategy,4) * 1 - '0';
    if ( length (val) < 2);
        val = [ 0 , val ];
    end
    res = '';
    for k = 1 : 2
        res =strcat(  res, getStr(val(k)));
        res =strcat(  res , ' ' );
    end
    strategyStr = res;


elseif ( posOfStrategy <= 85 )
    val = dec2base(85 - posOfStrategy,4) * 1 - '0';
    if ( length (val) < 3);
        val = [ zeros(1,3-length(val)) , val ];
    end
    res = '';
    for k = 1 : 3
        res =strcat(  res, getStr(val(k)));
        res =strcat(  res , ' ' );
    end
    strategyStr = res;

end


    function str = getStr(a)
        if ( a == 0 )
            str = 'CC';
        elseif ( a == 1 )
            str = 'CD';
        elseif ( a == 2 )
            str = 'DC';
        elseif ( a == 3 )
            str = 'DD';
        else 
            str = '!!';
        end
    end

end

