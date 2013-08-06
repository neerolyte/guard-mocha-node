require 'spec_helper'

describe Guard::MochaNode::SpecState do
  let(:state)  { Guard::MochaNode::SpecState.new }
  let(:runner) { Guard::MochaNode::Runner }

  describe "#initialize" do
    it "is passing" do
      state.should be_passing
    end

    it "has no failing paths" do
      state.failing_paths.should be_empty
    end

    it "is has not been fixed" do
      state.should_not be_fixed
    end
  end

  describe "#update" do
    let(:some_paths)   { %w(some paths) }
    let(:some_options) { double("some options") }

    before do
      runner.stub(:run => true)
    end

    it "runs the runner with the paths and options" do
      runner.should_receive(:run).with(some_paths, some_options).and_return(true)
      state.update(some_paths, some_options)
    end

    context "when the runner process exit value is zero" do
      before do
        state.update
      end

      it "is passing" do
        state.should be_passing
      end

      context "and there are run paths" do
        it "removes the run paths from the failing paths" do
          state.failing_paths = %w(/keep /remove)
          state.update(%w(/remove))
          state.failing_paths.should eql %w(/keep)
        end
      end

      context "and there are no run paths" do
        it "does not change the current failing paths" do
          original_failing_paths = %w(/keep1 /keep2)
          state.failing_paths = original_failing_paths
          state.update
          state.failing_paths.should eql original_failing_paths
        end
      end

      context "and the previous spec failed" do
        before do
          state.stub(:passing? => false)
          state.update
        end

        it "is fixed" do
          state.should be_fixed
        end
      end

      context "and the previous spec passed" do
        before do
          state.stub(:passing? => true)
          state.update
        end

        it "is not fixed" do
          state.should_not be_fixed
        end
      end
    end

    context "when the runner process exit value is not zero" do
      before do
        runner.stub(:run => false)
        state.update(some_paths, some_options)
      end

      it "is not passing" do
        state.should_not be_passing
      end

      it "is not fixed" do
        state.should_not be_fixed
      end

      context "and there are run paths" do
        it "updates the failing paths with the union of the failing paths and the run paths" do
          state.failing_paths = %w(/dupe /other)
          state.update(%w(/dupe /another))
          state.failing_paths.should =~ %w(/dupe /other /another)
        end
      end

      context "and there are no run paths" do
        it "does not change the current failing paths" do
          original_failing_paths = %w(/keep1 /keep2)
          state.failing_paths = original_failing_paths
          state.update
          state.failing_paths.should eql original_failing_paths
        end
      end
    end
  end
end
