for i=317:length(secs)
    secs{i} = update_rough_xy_for_overview_cropping(secs{i});
    secs = update_sec_tforms(secs, i);
end
