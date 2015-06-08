function z_matches = select_z_matches(secA, secB, stack)
%SELECT_Z_MATCHES Manually select Z matches.

if nargin < 3
    alignmentA = 'z';
    alignmentB = 'prev_z';
else
    alignmentA = 'stack_z';
    alignmentB = 'prev_stack_z';   
end

scale = 0.025;

% [A, R_A] = imshow_section(secA, 'tforms', secA.alignments.(alignmentA).tforms, 'suppress_display', true, 'display_scale', scale);
% [B, R_B] = imshow_section(secB, 'tforms', secB.alignments.(alignmentB).tforms, 'suppress_display', true, 'display_scale', scale);

[A, R_A] = imshow_section(secA, alignmentA);
[B, R_B] = imshow_section(secB, alignmentB);

ptsAin = [];
ptsBin = [];
%[ptsB, ptsA] = cpselect(B, A, ptsBin, ptsAin, 'Wait', true);

[ptsB, ptsA] = cpselect(B, A, 'Wait', true);

offsetA = [R_A.XWorldLimits(1), R_A.YWorldLimits(1)];
offsetB = [R_B.XWorldLimits(1), R_B.YWorldLimits(1)];

ptsA = bsxadd(ptsA, offsetA);
ptsB = bsxadd(ptsB, offsetB);

ptsA = ptsA / scale;
ptsB = ptsB / scale;

z_matches.A = table();
z_matches.B = table();
z_matches.A.global_points = ptsA;
z_matches.B.global_points = ptsB;


z_matches.num_matches = height(z_matches.A);
z_matches.secA = secA.name;
z_matches.secB = secB.name;
z_matches.alignmentA = alignmentA;
z_matches.alignmentB = alignmentB;
z_matches.match_type = 'z';
z_matches.meta.method = 'select_z_matches';
z_matches.meta.avg_error = rownorm2(z_matches.B.global_points - z_matches.A.global_points);

end

