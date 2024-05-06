defmodule Boggle do
  @moduledoc """
    Add your boggle function below. You may add additional helper functions if you desire. 
    Test your code by running 'mix test' from the tester_ex_simple directory.
  """

  #sanna banana 501154179

  def boggle(board, words) do

    word_set = MapSet.new(words) #creates a set of words
    trie = buildTrie(words) #builds prefix tree

    # dfs searches through each letter in the board starting w [0][0]
    Enum.reduce(0..(tuple_size(board)-1), %{}, fn x, acc -> #accumulates the empty map overtime
      Enum.reduce(0..(tuple_size(board)-1), acc, fn y, acc2 ->
        Map.merge(acc2, dfssearch(board, word_set, trie, {x, y}, "", %{}, [])) #merges the maps accumulated
      end)
    end)
  end

  #does a depth first search of the current letter, calls upon the function again using nextElement helper function (grabs the neighbouring letters)
  defp dfssearch(board, word_set, trie, {x, y}, currentWord, visited, position) do
    #makes sure x and y are within the board boundaries, else return empty map, AND THAT IT HAS NOT BEEN VISITED
    if x >= 0 and x < tuple_size(board) and y >= 0 and y < tuple_size(board) and not Map.has_key?(visited, {x, y}) do
      newWord = currentWord <> elem(elem(board, x), y) #concatenates the letter to the previously built word at [x,y]
      newPosition = [{x, y} | position] #adds the current position to the word builder coordinates thing
      newVisited = Map.put(visited, {x, y}, true) #marks the current position as visited

      if Map.has_key?(trie, newWord) do
        if newWord in word_set do #checks if word created so far is in the dictionary
          #puts the word in the map with its coordinates of letters (reversed for proper list of coords)
          Map.put(nextElement(board, word_set, trie, {x, y}, newWord, newVisited, newPosition), newWord, Enum.reverse(newPosition))
        else #otherwise add new letters
          nextElement(board, word_set, trie, {x, y}, newWord, newVisited, newPosition)
        end
      else
        %{} #if not in prefix tree, can instantly return the empty map as there are no words with the letters
      end
    else
      %{} #if was out of board bounds / already visited
    end
  end

  #checks neighbours in the corners, up, down, left, right, done similar to how we initiated dfs
  defp nextElement(board, word_set, trie, {x, y}, currentWord, visited, position) do
    Enum.reduce([-1, 0, 1], %{}, fn addx, acc -> #changes the row number: up, same, down
      Enum.reduce([-1, 0, 1], acc, fn addy, acc2 -> #changes the column number: left, same, right
        Map.merge(acc2, dfssearch(board, word_set, trie, {x+addx, y+addy}, currentWord, visited, position)) #diverges dfs into each neighbour
      end) end)
  end

  #creates a prefix tree, used to let the solver know that the current letters can build a word
  defp buildTrie(words) do
    Enum.reduce(words, %{}, fn word, trie -> #for each word, begin an empty map
      Enum.reduce(0..(String.length(word) - 1), trie, fn i, trie -> #to iterate through the letters
        prefix = String.slice(word, 0..i) #slices the words from its prefixes, ex) tree -> t, tr, tre, etc
        Map.put(trie, prefix, true) #puts each prefix within the prefix tree map
      end) end)
  end
end