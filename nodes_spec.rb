require './server.rb'
require 'rspec'
require './loaddata'

describe "server" do
  before(:all) do
    load_rows('./nodes2.csv', Node)
    load_rows('./birds2.csv', Bird)
  end

  describe "#depth" do
    subject { depth(Node.find(node_id)) }

    context "for root nodes" do
      let(:node_id) { 130 }

      it "returns 1" do
        expect(subject).to eq(1)
      end
    end

    context "for sub-sub-nodes" do
      let(:node_id) { 4430546 }

      it "returns 3 for sub-sub-nodes" do
        expect(subject).to eq(3)
      end
    end
  end

  describe "#lowest_common_ancestor" do
    subject { lowest_common_ancestor(Node.find(a), Node.find(b)) }

    context "descendant of sibling" do
      let(:a) { 5497637 }
      let(:b) { 2820230 }

      it "returns the parent" do
        expect(subject.id).to eq(125)
      end
    end

    context "descendant" do
      let(:a) { 5497637 }
      let(:b) { 130 }

      it "returns the ancestor" do
        expect(subject.id).to eq(130)
      end
    end

    context "child" do
      let(:a) { 5497637 }
      let(:b) { 4430546 }

      it "returns the parent" do
        expect(subject.id).to eq(4430546)
      end
    end

    context "self" do
      let(:a) { 4430546 }
      let(:b) { 4430546 }

      it "returns itself" do
        expect(subject.id).to eq(4430546)
      end
    end

    context "node that doesn't exist" do
      it "returns nil" do
        expect(lowest_common_ancestor(nil, Node.find(4430546))).to be_nil
      end
    end
  end

  describe "#root" do
    subject { root(Node.find(node_id)) }

    context "a root node" do
      let(:node_id) { 130 }

      it "returns the same node" do
        expect(subject.id).to eq(node_id)
      end
    end

    context "a child" do
      let(:node_id) { 125 }

      it "returns the root" do
        expect(subject.id).to eq(130)
      end
    end

    context "a child" do
      let(:node_id) { 5497637 }

      it "returns the root" do
        expect(subject.id).to eq(130)
      end
    end
  end

  describe "#nth_ancestor" do
    subject { nth_ancestor(Node.find(node_id), n) }

    context "0th ancestor of root" do
      let(:node_id) { 130 }
      let(:n) { 0 }

      it "is the root node" do
        expect(subject.id).to eq(130)
      end
    end

    context "1st ancestor of root" do
      let(:node_id) { 130 }
      let(:n) { 1 }

      it "is nil" do
        expect(subject).to be_nil
      end
    end

    context "1st ancestor of child of root" do
      let(:node_id) { 125 }
      let(:n) { 1 }

      it "is the root" do
        expect(subject.id).to eq(130)
      end
    end

    context "2nd ancestor of child of root" do
      let(:node_id) { 125 }
      let(:n) { 2 }

      it "is nil" do
        expect(subject).to be_nil
      end
    end
  end

  describe "#flock" do
    subject { flock(node_ids).sort }

    context "root node" do
      let(:node_ids) { [130] }

      it "returns all the birds in the tree" do
        expect(subject).to eq([1,2,3,4])
      end
    end

    context "root node with another node that doesn't have any birds" do
      let(:node_ids) { [130, 52] }

      it "returns the same as just the root node" do
        expect(subject).to eq([1,2,3,4])
      end
    end

    context "root node with another node in a separate tree" do
      let(:node_ids) { [130, 9] }

      it "returns the birds from that tree" do
        expect(subject).to eq([1,2,3,4,5])
      end
    end

    context "root node with node that doesn't exist" do
      let(:node_ids) { [130, 9999] }

      it "returns the birds from root's tree" do
        expect(subject).to eq([1,2,3,4])
      end
    end

    context "overlapping trees" do
      let(:node_ids) { [125, 5497637] }

      it "returns one of each bird" do
        expect(subject).to eq([1,2,3,4])
      end
    end

    context "separate trees" do
      let(:node_ids) { [2820230, 5497637] }

      it "returns the birds from each tree" do
        expect(subject).to eq([2,3,4])
      end
    end
  end
end