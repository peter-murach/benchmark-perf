# frozen_string_literal: true

RSpec.describe Benchmark::Perf::Execution do
  it "provides default benchmark range" do
    allow(described_class).to receive(:run_in_subprocess).and_return(0.1)

    described_class.run(warmup: 0) { "x" * 1024 }

    expect(described_class).to have_received(:run_in_subprocess).once
  end

  it "accepts custom number of samples" do
    allow(described_class).to receive(:run_in_subprocess).and_return(0.1)

    described_class.run(repeat: 3, warmup: 0) { "x" * 1024 }

    expect(described_class).to have_received(:run_in_subprocess).exactly(3).times
  end

  it "runs warmup cycles" do
    allow(described_class).to receive(:run_in_subprocess).and_return(0.1)

    described_class.run(repeat: 1, warmup: 1) { "x" }

    expect(described_class).to have_received(:run_in_subprocess).twice
  end

  it "doesn't run in subproces when option :run_in_subprocess is set to false",
     if: ::Process.respond_to?(:fork) do

    allow(::Process).to receive(:fork)

    described_class.run(subprocess: false) { "x" * 1024 }

    expect(::Process).to_not have_received(:fork)
  end

  it "doesn't run in subprocess when RUN_IN_SUBPROCESS env var is set to false",
     if: ::Process.respond_to?(:fork) do

    allow(::Process).to receive(:fork)
    allow(ENV).to receive(:[]).with("RUN_IN_SUBPROCESS").and_return("false")

    described_class.run { "x" * 1024 }

    expect(::Process).to_not have_received(:fork)
  end

  it "doesn't accept range smaller than 1" do
    expect {
      described_class.run(repeat: 0) { "x" }
    }.to raise_error(ArgumentError, "Repeat value: 0 needs to be greater than 0")
  end

  it "provides measurements for 30 samples by default" do
    sample = described_class.run(warmup: 0) { "x" * 1024 }

    expect(sample.to_a).to all(be < 0.01)
  end

  it "doesn't benchmark raised exception" do
    expect {
      described_class.run { raise "boo" }
    }.to raise_error(StandardError)
  end

  it "measures complex object" do
    sample = described_class.run(warmup: 0) { { foo: Object.new, bar: :piotr } }

    expect(sample.to_a).to all(be < 0.01)
  end

  it "executes code to warmup ruby vm" do
    sample = described_class.run_warmup { "x" * 1_000_000 }

    expect(sample).to eq(1)
  end

  it "measures work performance for 3 samples" do
    sample = described_class.run(repeat: 3) { "x" * 1_000 }

    expect(sample.to_a.size).to eq(3)
    expect(sample.to_a).to all(be < 0.02)
  end
end
