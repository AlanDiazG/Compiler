defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  setup_all do
    {:ok,
    ast:  %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 2
          },
          node_name: :return,
          right_node: nil,
          value: nil
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    },
    ast1:  %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 0
            },
            node_name: :return,
            right_node: nil,
            value: nil
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      },
      ast2:  %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 100
            },
            node_name: :return,
            right_node: nil,
            value: nil
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      },
      error_no_int: {:error, "Error, return type value missed"},
      error_no_main: {:error, "Error: main function missed"},
      error_no_open_paren: {:error, "Error: open parentesis missed"},
      error_no_close_paren: {:error, "Error: close parentesis missed"},
      error_no_open_brace: {:error, "Error: open brace missed"},
      error_no_return: {:error, "Error: return keyword missed"},
      error_no_number: {:error, "Error: constant value missed"},
      error_no_semicolon: {:error, "Error: semicolon missed after constant to finish return statement"},
      error_no_close_brace: {:error, "Error, close brace missed"},
      error_more_elements: {:error, "Error: there are more elements after function end"},
  }
end
 # tests to pass
  test "return 2", state do
    token_list = [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 2},
      :semicolon,
      :close_brace
    ]

    assert Parser.parse_program(token_list) == state[:ast]
  end
  test "return 0", state do
    token_list = [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 0},
      :semicolon,
      :close_brace
    ]

    assert Parser.parse_program(token_list) == state[:ast1]
  end
  test "multi_digit", state do
    token_list = [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 100},
      :semicolon,
      :close_brace
    ]

    assert Parser.parse_program(token_list) == state[:ast2]
  end
  test "new_lines", state do
    token_list = [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 2},
      :semicolon,
      :close_brace
    ]
    assert Parser.parse_program(token_list) == state[:ast]
  end
  test "no_newlines", state do
    token_list = [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 2},
      :semicolon,
      :close_brace
    ]
    assert Parser.parse_program(token_list) == state[:ast]
  end

  # tests to fail
  test "no_int_keyword", state do
    token_list=[
        :main_keyword,
        :open_paren,
        :close_paren,
        :open_brace,
        :return_keyword,
        {:constant, 2},
        :semicolon,
        :close_brace]
        assert Parser.parse_program(token_list) == state[:error_no_int]
  end
  test "no_main", state do
    token_list=[
        :int_keyword,
        :open_paren,
        :close_paren,
        :open_brace,
        :return_keyword,
        {:constant, 2},
        :semicolon,
        :close_brace]
        assert Parser.parse_program(token_list) == state[:error_no_main]
  end
  test "missing_open_paren", state do
   token_list=[
        :int_keyword,
        :main_keyword,
        :close_paren,
        :open_brace,
        :return_keyword,
        {:constant, 2},
        :semicolon,
        :close_brace]
        assert Parser.parse_program(token_list) == state[:error_no_open_paren]
  end
  test "missing_close_paren", state do
    token_list=[
        :int_keyword,
        :main_keyword,
        :open_paren,
        :open_brace,
        :return_keyword,
        {:constant, 2},
        :semicolon,
        :close_brace]
        assert Parser.parse_program(token_list) == state[:error_no_close_paren]
  end
  test "no_open_brace", state do
    token_list=[
        :int_keyword,
        :main_keyword,
        :open_paren,
        :close_paren,
        :return_keyword,
        {:constant, 2},
        :semicolon,
        :close_brace]
        assert Parser.parse_program(token_list) == state[:error_no_open_brace]
  end
  test "no_return", state do
    token_list=[
        :int_keyword,
        :main_keyword,
        :open_paren,
        :close_paren,
        :open_brace,
        {:constant, 2},
        :semicolon,
        :close_brace]
        assert Parser.parse_program(token_list) == state[:error_no_return]
  end
  test "no_number", state do
    token_list=[
        :int_keyword,
        :main_keyword,
        :open_paren,
        :close_paren,
        :open_brace,
        :return_keyword,
        :semicolon,
        :close_brace]
        assert Parser.parse_program(token_list) == state[:error_no_number]
  end
  test "no_semicolon", state do
    token_list=[
        :int_keyword,
        :main_keyword,
        :open_paren,
        :close_paren,
        :open_brace,
        :return_keyword,
        {:constant, 2},
        :close_brace]
        assert Parser.parse_program(token_list) == state[:error_no_semicolon]
end
test "no_close_brace", state do
  token_list=[
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 2},
      :semicolon]
      assert Parser.parse_program(token_list) == state[:error_no_close_brace]
end
test "more element", state do
  token_list=[
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 2},
      :semicolon,
      :close_brace,
      :close_brace]
      assert Parser.parse_program(token_list) == state[:error_more_elements]
end
end
