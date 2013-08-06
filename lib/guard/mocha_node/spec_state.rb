module Guard
  class MochaNode
    class SpecState
      attr_accessor :failing_paths

      def initialize
        clear!
      end

      def update(run_paths = [], options = {})
        @run_paths = run_paths
        @exitok = Runner.run(@run_paths, options)
        update_passed_and_fixed
        update_failing_paths
        passing?
      end

      def passing?
        @passed
      end

      def fixed?
        @fixed
      end

      def clear!
        @passed = true
        @fixed  = false
        @failing_paths = []
      end

      private

      def update_passed_and_fixed
        previously_failed = !passing?
        @passed = @exitok
        @fixed  = @passed && previously_failed
      end

      def update_failing_paths
        if @run_paths.any?
          @failing_paths = if passing?
                             @failing_paths - @run_paths
                           else
                             @failing_paths + @run_paths
                           end.uniq
        end
      end
    end
  end
end
