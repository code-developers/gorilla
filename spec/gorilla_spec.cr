require "./spec_helper"

describe Gorilla do
  it "runs the spec suite" do
    
    Process.run("mkdir", [
      "bin",
    ])

    Process.run("crystal", [
      "build",
      "src/gorilla.cr",
      "--release",
      "--stats",
      "-o",
      "bin/gorilla",
    ], output: STDOUT, input: STDIN, error: STDERR)

    Process.run("export", [
      "GORILLADIR=./",
    ])

    result = Process.run("./bin/gorilla", [
      "test/main.ch",
    ], output: STDOUT, input: STDIN, error: STDERR)

    result.exit_status.should eq(0)
  end
end