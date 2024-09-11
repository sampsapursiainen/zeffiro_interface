classdef Zef < handle
%
% Zef < handle
%
% A handle class holding onto core data, that is utilized by Zeffiro Interface.
%
    properties

        nodes (:,3) double { mustBeFinite } = []

        tetra (:,4) double { mustBePositive, mustBeInteger } = []

        A (:,:) double { mustBeFinite } = sparse ([])

        T (:,:) double { mustBeFinite } = []

        L (:,:) double { mustBeFinite } = []

        sourcePos (:,3) double { mustBeFinite } = []

        sourceTetI (:,1) double { mustBePositive, mustBeInteger } = []

    end % properties

    methods

        function self = Zef (kwargs)
        %
        % self = Zef (kwargs)
        %
        % A constructor for this class.
        %

            arguments
                kwargs.nodes = []
                kwargs.tetra = []
                kwargs.A = sparse ([])
                kwargs.T = []
                kwargs.L = []
                kwargs.sourcePos = []
                kwargs.sourceTetI = []
            end

            fieldNames = string ( fieldnames (kwargs) ) ;

            for fI = 1 : numel (fieldNames)

                fieldName = fieldNames (fI) ;

                self.(fieldName) = kwargs.(fieldName) ;

            end % for

        end % function

    end % methods

end % classdef
