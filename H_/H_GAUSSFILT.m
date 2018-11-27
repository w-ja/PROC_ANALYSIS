function [new_positions,gfiltered_CSD] = H_GAUSSFILT(positions,unfiltered_CSD,gauss_sigma,filter_range)

if nargin<4; filter_range = 5*gauss_sigma; end;

step = positions(2)-positions(1);
filter_positions = -filter_range/2:step:filter_range/2;
gaussian_filter = 1/(gauss_sigma*sqrt(2*pi))*exp(-filter_positions.^2/(2*gauss_sigma^2));

filter_length = length(gaussian_filter);
[m,n]=size(unfiltered_CSD);
temp_CSD=zeros(m+2*filter_length,n);
temp_CSD(filter_length+1:filter_length+m,:)=unfiltered_CSD(:,:);
scaling_factor = sum(gaussian_filter);
temp_CSD = filter(gaussian_filter/scaling_factor,1,temp_CSD);
gfiltered_CSD=temp_CSD(round(1.5*filter_length)+1:round(1.5*filter_length)+m,:);

new_positions = positions;
end
