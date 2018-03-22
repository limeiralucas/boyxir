defmodule Z80 do
	@moduledoc """
	Simulate the modified Zilog Z80 processor used by Gameboy
	"""

	@doc """
	Returns a initial processor state

	"""
	@spec init_state() :: Map
	def init_state() do
		%{
			_clock: %{m: 0, t: 0},
			_r: %{
				a: 0,
				b: 0,
				c: 0,
				d: 0,
				e: 0,
				h: 0,
				l: 0,
				f: 0,
				pc: 0,
				sp: 0,
				m: 0,
				t: 0
			}
		}
	end

	@doc """
	Sum values of register A and E storing the result in register A

	## Parameters

	  - registers: A map representing the actual state of registers.

	"""
	@spec addr_e(Map) :: Map
	def addr_e(registers) do
		sum = registers[:a] + registers[:e]
		%{registers | a: sum}
	end

	@doc """
	Compare register B to A, setting flags

	## Parameters
	 - registers: A map representing the actual state of registers.

	"""
	@spec cpr_b(Map) :: Map
	def cpr_b(registers) do
		subtraction = registers[:a] - registers[:b]
		cond do
			subtraction == 0 ->
				%{registers | f: 0x80, m: 1, t: 4}
			subtraction < 0 ->
				%{registers | f: 0x10, m: 1, t: 4}
		end
	end


	@doc """
	Represents No-operation (NOP) of processor

	## Parameters
	 - registers: A map representing the actual state of registers.

	"""
	@spec nop(Map) :: Map
	def nop(registers) do
		%{registers | m: 1, t: 4}
	end


	@doc """
	Push registers B and C to the stack

	## Parameters
	 - registers: A map representing the actual state of registers.

	"""
	def pushbc(registers) do
		t_sp = registers[:sp] - 1
		MMU.wb(t_sp, registers[:b])
		t_sp = registers[:sp] - 1
		MMU.wb(t_sp, registers[:c])

		%{registers | sp: t_sp, m: 3, t: 12}
	end

	@doc """
	Pop registers H and L off the stack

	## Parameters
	 - registers: A map representing the actual state of registers.

	"""
	def pophl(registers) do
		t_sp = registers[:sp]
		t_l = MMU.rb(t_sp)
		t_sp = t_sp + 1
		t_h = MMU.rb(t_sp)
		t_sp = t_sp + 1

		%{registers | sp: t_sp, h: t_h, l: t_l, m: 3, t: 12}
	end


	@doc """
	Read a byte from absolute location into A

	## Parameters
	 - registers: A map representing the actual state of registers.

	"""
	def ldamm(registers) do
		t_pc = registers[:pc]
		addr = MMU.rw(t_pc)
		t_pc = t_pc + 2
		t_a = MMU.rb(addr)

		%{registers | pc: t_pc, a: t_a, m: 4, t: 16}
	end
end