function count = compartment_count ( self )
%
% count = compartment_count ( self )
%
% produces the number of compartments in a given segmentation.
%

    count = max ( self.labels ) ;

end % function
