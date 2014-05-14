function bounding_boxes = sec_bb(sec, alignment, return_aabb)
%SEC_BB Returns an array of bounding boxes for a section after the specified alignment.
% Usage:
%   bounding_boxes = sec_bb(sec)
%   bounding_boxes = sec_bb(sec, alignment)
%   bounding_boxes = sec_bb(sec, alignment, true)
%
% Args:
%   sec is a structure generated by load_sec.
%   alignment is a string specifying the alignment to use. Defaults to the
%       last alignment added to sec.alignments, or a grid if only the
%       initial alignment is present.
%   return_aabb is a boolean. If true, this function returns the
%       axis-aligned bounding boxes of the transformed initial bounding
%       boxes. When this is false, there is no guarantee that the output
%       will be axis-aligned. Defaults to false.
%
% Returns:
%   bounding_boxes a cell array of the bounding boxes of each tile.
%
% Note:
%   This applies the transforms of the specified alignment to the
%   bounding boxes, does not account for a change in resolution. Use
%   tform_bb2bb to get the actual bounding box of a tile image after it is
%   transformed by imwarp().
%
% See also: ref_bb, tform_bb2bb, sz2bb, plot_regions, plot_section

alignments = fieldnames(sec.alignments);
use_grid = false;
if nargin < 2
    % Get last alignment
    alignment = alignments{end};
    
    % Use grid alignment if the last alignment is the initial (all identity).
    use_grid = strcmp(alignment, 'initial');
end
if nargin < 3; return_aabb = false; end

% Figure out which transforms to use
if use_grid
    grid_alignment = get_grid_alignment(sec);
    tforms = grid_alignment.tforms;
else
    alignment = validatestring(alignment, fieldnames(sec.alignments));
    tforms = sec.alignments.(alignment).tforms;
end

% Calculate bounding boxes
bounding_boxes = cell(sec.num_tiles, 1);
for i = 1:sec.num_tiles
    % Get an initial bounding box based on the tile size
    bb = sz2bb(sec.tile_sizes{i});
    
    % Apply alignment transform
    bb = tforms{i}.transformPointsForward(bb);
    
    if return_aabb
        % Convert transformed bounding box to an axis-aligned bounding box
        bb = minaabb(bb);
    end
    
    % Save to array
    bounding_boxes{i} = bb;
end
end

