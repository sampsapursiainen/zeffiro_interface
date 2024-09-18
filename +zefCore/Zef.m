classdef Zef < handle
%
% Zef < handle
%
% A handle class holding onto core data, that is utilized by Zeffiro Interface.
%
    properties

        eegL (:,:) double { mustBeFinite } = [] % An EEG lead field matrix.

        filedTransferMat (1,1) matlab.io.MatFile = matfile ("T.mat") % A file handle to a transfer matrix stored on disk.

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
                kwargs.filedTransferMat = matfile("T.mat")
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

        function self = withStiffnessMat (self, A)
        %
        % self = set.withStiffnessMat (self, A)
        %
        % A setter for self.stiffnessMat.
        %

            arguments
                self
                A (:,:) double { mustBeFinite }
            end

            nodeN = size ( self.nodes, 1 ) ;

            [rowN, colN] = size (A) ;

            assert ( rowN == nodeN && colN == nodeN, "A stiffness matrix needs to have as many rows and columns as there are nodes in the related mesh."  ) ;

            self.stiffnessMat = A ;

        end % function

        function self = withTransferMat (self, T)
        %
        % self = set.withTransferMat (self, T)
        %
        % A setter for self.filedTransferMat, that ensures the MatFile object
        % becomes unwritable after its value has been set.
        %

            arguments
                self
                T
            end

            self.filedTransferMat.Properties.Writable = true ;

            self.filedTransferMat.T = T ;

            self.filedTransferMat.Properties.Writable = false ;

        end % function

        function T = transferMat (self)
        %
        % T = self.transferMat (self)
        %
        % A getter for self.filedTransferMat, that returns the value of the contained transfer matrix.
        %

            arguments
                self
            end

            T = self.filedTransferMat.T ;

        end % function

    end % methods

end % classdef
