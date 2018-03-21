defmodule Z80 do
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

	def addr_e(registers) do
		sum = registers[:a] + registers[:e]
		%{registers | a: sum}
	end

	def cpr_b(registers) do
		subtraction = registers[:a] - registers[:b]
		cond do
			subtraction == 0 ->
				%{registers | f: 0x80, m: 1, t: 4}
			subtraction < 0 ->
				%{registers | f: 0x10, m: 1, t: 4}
		end
	end

	def nop(registers) do
		%{registers | m: 1, t: 4}
	end

	def pushbc(registers) do
		t_sp = registers[:sp] - 1
		MMU.wb(t_sp, registers[:b])
		t_sp = registers[:sp] - 1
		MMU.wb(t_sp, registers[:c])

		%{registers | sp: t_sp, m: 3, t: 12}
	end

	def pophl(registers) do
		t_sp = registers[:sp]
		t_l = MMU.rb(t_sp)
		t_sp = t_sp + 1
		t_h = MMU.rb(t_sp)
		t_sp = t_sp + 1

		%{registers | sp: t_sp, h: t_h, l: t_l, m: 3, t: 12}
	end

	def ldamm(registers) do
		t_pc = registers[:pc]
		addr = MMU.rw(t_pc)
		t_pc = t_pc + 2
		t_a = MMU.rb(addr)

		%{registers | pc: t_pc, a: t_a, m: 4, t: 16}
	end
end