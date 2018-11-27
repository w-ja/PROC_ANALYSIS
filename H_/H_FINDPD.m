function pd_act = H_FINDPD(pd,times,varargin)

% Set defaults
nRMSstart = 2;
sampWind = 5;
alph = .05;
smoothAmnt = 10;
offset = 10;

xVals = pd;
yVals = pd;

% Get the hypotenuse of the x,y vector via Pythagorean theorem
hyp = sqrt(xVals.^2+yVals.^2);

% Now calculate the differences in x position, y position, and
% hypotenuse
deltT = diff(times);
deltH = diff(hyp);

% dx = deltX/deltT; same for y
dh = deltH./deltT;

% Smooth dh for better SNR
% dh = H_RUNAVE(dh,smoothAmnt);
dh(isnan(dh)) = 0;

rmsH = rms(dh);

dhShift = [dh(2:end),nan];
overInds = find(H_FINDCONSEC(dh >= nRMSstart*rmsH) == 0 & ...
    H_FINDCONSEC(dhShift >= nRMSstart*rmsH) > 0);

overInds = overInds+offset;
overInds(overInds > length(hyp)) = [];

% overInds = find(dh >= nRMSstart*rmsH & dhShift < nRMSstart*rmsH);

startInds = nan(1,length(overInds));
endInds = nan(1,length(overInds));

startDiff = 0;
while sum(isfinite(startInds)) < length(startInds)

    subInds = find(isnan(startInds));

    matInds = bsxfun(@plus,overInds(subInds)+startDiff,(-sampWind:sampWind)');
    matInds(matInds < 0 | matInds > length(hyp)) = 1;
    hypCheck = hyp(matInds);

    if size(hypCheck,1) == 1, hypCheck = hypCheck'; end

    [~,p] = corr((1:size(hypCheck,1))',hypCheck);

    pCheck = nan(1,length(startInds));
    pCheck(subInds) = p;
    startInds(isnan(startInds) & pCheck >= alph) = overInds(isnan(startInds) & pCheck >= alph)+startDiff;
    startDiff = startDiff-1;
end

endDiff = 0;
while sum(isfinite(endInds)) < length(endInds)

    subInds = find(isnan(endInds));
    matInds = bsxfun(@plus,overInds(subInds)+endDiff,(-sampWind:sampWind)');
    matInds(matInds < 0 | matInds > length(hyp)) = 1;
    hypCheck = hyp(matInds);

    if size(hypCheck,1) == 1, hypCheck = hypCheck'; end

    [~,p] = corr((1:size(hypCheck,1))',hypCheck);

    pCheck = nan(1,length(endInds));
    pCheck(subInds) = p;
    endInds(isnan(endInds) & pCheck >= alph) = overInds(isnan(endInds) & pCheck >= alph)+endDiff;
    endDiff = endDiff+1;

end

endCheck=[[startInds(2:end),nan];endInds];cutInds = find(endCheck(1,:) < endCheck(2,:))+1;
startInds(cutInds) = [];

pd_act = times(startInds(startInds <= length(times)));

end