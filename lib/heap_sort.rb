require_relative "heap"

class Array
  def heap_sort!
    prc = Proc.new {|a,b| -1 * (a<=>b)} #using BMH as a MaxHeap to have elements sorted from smallest to biggest

    1.upto(count) do |num|
      next if num == self.length #can't have index be the array length

      #line 40 changes the Array each iteration. You start at
      #index one because you can't heapify up an element at index 0.
      BinaryMinHeap.heapify_up(self, num, count, &prc)
    end

    #Array is now a heap.

    # Extract, starting right to left. Heapify down, since each [0] element will now be out of place.
  right_hand = count - 1     #array[count - 1]
  right_hand.downto(1) do |num|
    self[0], self[num] = self[num], self[0]
    BinaryMinHeap.heapify_down(self, 0, num, &prc)  #each iteration/number can be thought of as the heap_size you're working with.
  end

  self

  end
end
