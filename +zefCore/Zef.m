classdef Zef < handle
%
% Zef < handle
%
% A handle class holding onto core data, that is utilized by Zeffiro Interface.
%
    properties

        eegL (:,:) double { mustBeFinite } = [] % An EEG lead field matrix.

        filedTransferMat (1,1) matlab.io.MatFile = [] % A file handle to a transfer matrix stored on disk.

        gmegL (:,:) double { mustBeFinite } = [] % A gMEG lead field matrix.

        megL (:,:) double { mustBeFinite } = [] % An MEG lead field matrix.

        nodes (:,3) double { mustBeFinite } = [] % Nodes in a finite element mesh.

        sourcePos (:,3) double { mustBeFinite } = [] % Positions of sources in an active volume.

        sourceTetI (:,1) double { mustBePositive, mustBeInteger } = [] % Indices of the tetra which function as possible source locations.

        stiffnessMat (:,:) double { mustBeFinite } = sparse ([]) % A cached stiffness matrix.

        tesL (:,:) double { mustBeFinite } = [] % An tES lead field matrix.

        tetra (:,4) double { mustBePositive, mustBeInteger } = [] % Elements or quadruples of node indices in a finite element mesh.

    end % properties

    methods

        function self = Zef (kwargs)
        %
        % self = Zef (kwargs)
        %
        % A constructor for this class.
        %

            arguments
                kwargs.eegL = []
                kwargs.filedTransferMat = []
                kwargs.gmegL = []
                kwargs.megL = []
                kwargs.nodes = []
                kwargs.sourcePos = []
                kwargs.sourceTetI = []
                kwargs.stiffnessMat = sparse ([])
                kwargs.tesL = []
                kwargs.tetra = []
            end

            fieldNames = string ( fieldnames (kwargs) ) ;

            for fI = 1 : numel (fieldNames)

                fieldName = fieldNames (fI) ;

                self.(fieldName) = kwargs.(fieldName) ;

            end % for

        end % function

    end % methods

end % classdef
