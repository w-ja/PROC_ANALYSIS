function [ digi_rec, digi_head ] = H_REC()

try
    [ num, txt ] = xlsread( 'C:\Users\Jake Westerberg\Dropbox\record_digital.xlsx' );
catch
    try
        [ num, txt ] = xlsread( '/Users/jakew/Dropbox/record_digital.xlsx' );
    catch
        [ num, txt ] = xlsread( '/Users/westerja/Dropbox/record_digital.xlsx' );
    end
end
num = mat2cell(num,ones(size(num,1),1), ones(size(num,2),1));
txt( 2:end, ~isnan( [num{1,:}] ) ) = num( :, ~isnan( [num{1,:}] ) );

head_temp = txt( 1,: );
digi_rec = txt( 2:end, : );

ctr = 1;
for i = head_temp
    eval(['digi_head.' cell2mat(i) '=' num2str(ctr) ';' ] )
    ctr = ctr + 1;
end

end