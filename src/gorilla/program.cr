require "./syntax/ast.cr"

module Gorilla
  class Program
    property path : String
    property tree : AST::Block
    property tokens : Array(Token)

    def initialize(@path, @tree, @tokens)
    end
  end
end