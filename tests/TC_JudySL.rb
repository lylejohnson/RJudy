require 'test/unit'
require 'judy'

include Judy

class TC_JudySL < Test::Unit::TestCase
  def set_up
    @array = JudySL.new
  end
  
  def test_insert
    @array["foo"] = 3.14159
    GC.start
    assert_equal(1, @array.size)
  end
  
  def test_delete
    @array["answer"] = 42
    assert_equal(42, @array.delete("answer"))
    assert_equal(nil, @array.delete("answer"))
  end
  
  def test_get
    @array["spam"] = 67
    assert_equal(67, @array["spam"])
    assert_equal(nil, @array["bar"])
  end
  
  def test_free_array
    assert_equal(0, @array.free_array)
    @array["foo"] = 3.14159
    assert(@array.free_array > 0)
  end
  
  def test_first_key
    @array["c"] = 3
    @array["a"] = 1
    @array["b"] = 2
    assert_equal("a", @array.first_key)
    assert_equal("a", @array.first_key(""))
    assert_equal("c", @array.first_key("bb"))
  end
  
  def test_next_key
    @array["one"] = 1
    @array["two"] = 2
    @array["three"] = 3
    assert_equal("one", @array.next_key("abc"))
    assert_equal("three", @array.next_key("one"))
    assert_equal("two", @array.next_key("thrush"))
    assert_nil(@array.next_key("two"))
  end
  
  def test_last_key
    assert_nil(@array.last_key)
    assert_nil(@array.last_key("b"))
    @array["c"] = 3
    @array["a"] = 1
    @array["b"] = 2
    assert_equal("c", @array.last_key)
    assert_equal("b", @array.last_key("b"))
  end
  
  def test_prev_key
    assert_nil(@array.prev_key("d"))
    @array["c"] = 3
    @array["a"] = 1
    @array["b"] = 2
    assert_equal("c", @array.prev_key("d"))
    assert_nil(@array.prev_key("a"))
  end
  
  def test_clear
    @array["spam"] = 67
    assert(@array.has_key?("spam"))
    @array.clear
    assert(!@array.has_key?("spam"))
  end
  
  def test_has_key?
    @array["foo"] = 1
    assert( @array.has_key?("foo"))
    assert(!@array.has_key?("bar"))
  end
  
  def test_each
    @array["A"] = 1
    @array["B"] = 2
    @array["C"] = 3
    sumKeys = ""
    sumValues = 0
    @array.each do |key, value|
      sumKeys += key
      sumValues += value
    end
    assert_equal("ABC", sumKeys)
    assert_equal(6, sumValues)
  end
  
  def test_each_key
    @array["A"] = 1
    @array["B"] = 2
    @array["C"] = 3
    sumKeys = ""
    @array.each_key { |key| sumKeys += key }
    assert_equal("ABC", sumKeys)
  end
  
  def test_each_value
    @array["A"] = 1
    @array["B"] = 2
    @array["C"] = 3
    sumValues = 0
    @array.each_value { |value| sumValues += value }
    assert_equal(6, sumValues)
  end
  
  def test_keys
    assert_kind_of(Array, @array.keys)
    assert_equal(0, @array.keys.length)
    @array["a"] = ?a
    @array["b"] = ?b
    @array["c"] = ?c
    assert_equal(3, @array.keys.length)
    assert_equal("abc", @array.keys.sort.join)
  end
  
  def test_values
    assert_kind_of(Array, @array.values)
    assert_equal(0, @array.values.length)
    @array["a"] = ?a
    @array["b"] = ?b
    @array["c"] = ?c
    assert_equal(3, @array.values.length)
  end
  
  def test_length
    assert_equal(0, @array.length)
    @array["a"] = ?a
    @array["b"] = ?b
    @array["c"] = ?c
    assert_equal(3, @array.length)
  end
  
  def test_to_a
    @array["a"] = ?a
    @array["b"] = ?b
    @array["c"] = ?c
    ary = @array.to_a
    assert_kind_of(Array, ary)
    assert_equal(3, ary.length)
    ary.each do |pair|
      assert_kind_of(Array, pair)
      assert_equal(2, pair.length)
    end
  end
  
  def test_to_s
    assert_equal("", @array.to_s)
    @array["a"] = ?a
    @array["b"] = ?b
    @array["c"] = ?c
    assert_equal("a97b98c99", @array.to_s)
  end
end
