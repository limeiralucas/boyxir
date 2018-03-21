defmodule Z80Test do
  use ExUnit.Case
  doctest Z80

  test "init state" do
    assert Z80.init_state == %{
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

  test "addr_e" do
  	state = Z80.init_state
  	registers = %{ state[:_r] | a: 1, e: 3 }

  	state = %{state | _r: Z80.addr_e(registers) }

  	assert state == %{
			_clock: %{m: 0, t: 0},
			_r: %{
				a: 4,
				b: 0,
				c: 0,
				d: 0,
				e: 3,
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
end
