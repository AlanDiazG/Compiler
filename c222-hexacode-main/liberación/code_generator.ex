defmodule CodeGenerator do
  def generate_code(ast) do
      {_,esp}=:os.type()
      code = post_order(ast,esp)
      IO.puts("\nCode Generator output:")
      IO.puts(code)
      code

  end

  def post_order(node,esp) do
      case node do
          nil ->
              nil
          ast_node ->
            code_snippet = post_order(ast_node.left_node,esp)
              emit_code(ast_node.node_name,code_snippet ,ast_node.value,esp)
      end
  end
  def emit_code(:program, code_snippet , _, os) when os == :darwin do
      """
          .section        __TEXT,__text,regular,pure_instructions
          .p2align        4, 0x90
      """ <>
      code_snippet
  end


  def emit_code(:program, code_snippet , _, _) do

      code_snippet
  end

  def emit_code(:function, code_snippet , :main, os) when os == :linux do
      """
          .globl  main
      main:
      """ <>
      code_snippet
  end

  def emit_code(:function, code_snippet , :main, _) do
      """
          .globl  _main
      _main:
      """ <>
      code_snippet
  end
  def emit_code(:return, code_snippet, _, _) do
      """
          movl    #{code_snippet }, %eax
          ret
      """
  end

  def emit_code(:constant, _, value, _) do
      "$#{value}"
  end

end


















