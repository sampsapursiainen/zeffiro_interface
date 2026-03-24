classdef Waitbar < handle
%
% Waitbar < handle
%
% A textual "waitbar" that supports parallel processing in loops and spmd
% blocks. Relies on MATLAB's DataQueue to block parallel updates (data races)
% between workers. Automatically updates output when increments at a given
% print interval are reached.
%
% Inspired by https://se.mathworks.com/matlabcentral/answers/465911-parfor-waitbar-how-to-do-this-more-cleanly#answer_378518 .
%

    properties (Access=private, Transient)
        currentIter (1,1) double { mustBeNonnegative, mustBeInteger } = 0
        printInterval (1,1) double { mustBePositive, mustBeInteger } = 1
    end

    properties (SetAccess=immutable, GetAccess=private)
        fileID (1,1) double { mustBePositive, mustBeInteger } = 1
        maxIter (1,1) double { mustBePositive, mustBeInteger } = 1
        queue (1,1) parallel.pool.DataQueue = parallel.pool.DataQueue
    end % properties (SetAccess=Immutable)

    properties (SetAccess = immutable, GetAccess = private, Transient)
        listener (:,1) event.listener = event.listener.empty
    end

    methods

        function self = Waitbar (kwargs)
        %
        % self = Waitbar (kwargs)
        %
        % A constructor for this class. Properties are set via keyword arguments.
        %

            arguments
                kwargs.maxIter = 1
                kwargs.queue = parallel.pool.DataQueue
                kwargs.fileID = 1
                kwargs.printInterval = 0
            end

            if kwargs.printInterval == 0

                kwargs.printInterval = ceil ( kwargs.maxIter / 100 ) ;

            end % if

            fieldNames = string ( fieldnames (kwargs) ) ;

            fieldN = numel (fieldNames) ;

            for ii = 1 : fieldN

                fieldName = fieldNames (ii) ;

                self.(fieldName) = kwargs.(fieldName) ;

            end % for

            self.currentIter = 0 ;

            % Attach listener to increment counter in self after every modification of self.queue.

            self.listener = afterEach ( self.queue, @(~) privateIncrement (self) ) ;

        end % function

        function self = increment (self)
        %
        % self = increment (self)
        %
        % Increments the counter within self.
        %

            send (self.queue, true) ;

        end % function

        function delete(self)
        %
        % delete(self)
        %
        % Takes care that all handles within self are closed.
        %

            delete (self.queue);

        end % function

    end % methods

    methods (Access=private)

        function self = privateIncrement (self)
        %
        % self = privateIncrement (self)
        %
        % Increments the value of the current counter in self.
        %

            self.currentIter = self.currentIter + 1 ;

            zefCore.dispProgress ( self.currentIter, self.maxIter, printInterval=self.printInterval, fileDescriptor=self.fileID ) ;

        end % function

    end % methods (Access=Private)

end % classdef
