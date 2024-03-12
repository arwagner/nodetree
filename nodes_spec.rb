require './server.rb'
require 'rspec'

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