# Seyon Rajagoapal
# CPS 506 Assignment - Elixir
# Poker game that deals 2 hands of 5 cards and determines the winner. Program also assumes correct input is given

defmodule Poker do 
  #function that deals the cards and determines winner
  def deal(list) do
    #seperate hands
    hand1 = Enum.take_every(list,2)
    hand2 = Enum.take_every((tl list),2)

    # deck with 1 defined as 14
    deck = createDeck()

    #convert hand in form of cards and suites
    convertedhand1 = convertHand(sortHand(hand1), deck)
    convertedhand2 = convertHand(sortHand(hand2), deck)
        
    #create new deck with 1 defined as 1
    newDeck = createDeck2()

    #convert values to desired format
    outputhand1 = convertHand(sortHand2(hand1), newDeck)
    outputhand2 = convertHand(sortHand2(hand2), newDeck)

    IO.puts ""
    IO.puts ""
    IO.inspect hand1, charlists: :as_lists

    IO.inspect convertedhand1
    IO.inspect evalHand(convertedhand1)
    IO.puts ""
    IO.inspect hand2, charlists: :as_lists

    IO.inspect convertedhand2
    IO.inspect evalHand(convertedhand2)
    IO.puts ""

    #determine winner and output in desired format
    if (evalHand(convertedhand1)>= evalHand(convertedhand2)) do
      Enum.flat_map(outputhand1, fn {x, y} -> [Integer.to_string(x)<>y] end)
    else
      Enum.flat_map(outputhand2, fn {x, y} -> [Integer.to_string(x)<>y] end)
    end
  end
  
  #function to sort the hand in numrical order ex. 22351
  def sortHand(hand) do 
    sortedhand = Enum.sort(hand, &(rem(&1-1,13) <= rem(&2-1,13)))
    appendAceEnd(sortedhand)
  end

  #function to sort the hand in numrical order ex. 12235 (without appending ace to end)
  def sortHand2(hand) do 
    Enum.sort(hand, &(rem(&1-1,13) <= rem(&2-1,13)))
  end

  #function to convert cards 
  def convertHand(hand, deck) do
    for x <- hand do
      Enum.at(deck,x-1)
    end
  end

  #function to add the ace to end of deck
  def appendAceEnd(hand) do
    if (rem((hd hand), 13) != 1) do
      hand
    else
      appendAceEnd((tl hand) ++ [hd hand])
    end
  end

  #function to create a deck of cards with ace defined as 14
  def createDeck do
    for suit <- ["C", "D", "H", "S"],
       face <- [14, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
       do: {face,suit}
  end

  #function to create a deck of cards with ace defined as 1
  def createDeck2 do
    for suit <- ["C", "D", "H", "S"],
       face <- [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
       do: {face,suit}
  end

  #functions below use pattern matching and method overloading to determine what the hand is. flush, straight, etc...

  #conditions to check for royal-flush
  def evalHand([{10, s}, {11, s}, {12, s}, {13, s}, {14, s}]) do
     {10,(:binary.first s),0,0,0,0,0} 
  end
 
  #condition to check for straight-flush
  def evalHand([{a, s}, {_b, s}, {_c, s}, {_d, s}, {e, s}]) when e - a == 4 do
    {9,e,(:binary.first s),0,0,0,0}
  end

  def evalHand([{2, s}, {3, s}, {4, s}, {5, s}, {14, s}]) do 
    {9,5,(:binary.first s),0,0,0,0} 
  end 

  #conditions to check for four-of-a-kind
  def evalHand([{a, _}, {a, _}, {a, _}, {a, s}, {b, _}]) do
    {8,a,b,(:binary.first s),0,0,0}
  end 
  
  def evalHand([{b, _}, {a, _}, {a, _}, {a, _}, {a, s}]) do 
    {8,a,b,(:binary.first s),0,0,0}
  end

  #conditions to check for full-house
  def evalHand([{a, _}, {a, _}, {a, s}, {b, _}, {b, _}]) do 
    {7,a,b,(:binary.first s),0,0,0}
  end  

  def evalHand([{b, _}, {b, _}, {a, _}, {a, _}, {a, s}]) do 
    {7,a,b,(:binary.first s),0,0,0}
  end


  # condition to check for flush
  def evalHand([{e, s}, {d, s}, {c, s}, {b, s}, {a, s}]) do 
    {6,a,b,c,d,e,(:binary.first s)} 
  end 

  #conditions to check for straight
  def evalHand([{a, _}, {b, _}, {c, _}, {d, _}, {e, s}]) when a + 1 == b and b + 1 == c and c + 1 == d and d + 1 == e do 
    {5,e,(:binary.first s),0,0,0,0} 
  end 

  def evalHand([{2, _}, {3, _}, {4, _}, {5, _}, {14, s}]) do 
    {5,5,(:binary.first s),0,0,0,0}
  end

  #conditions to check for three-of-a-kind
  def evalHand([{a, _}, {a, _}, {a, s}, {c, _}, {b, _}]) do 
    {4,a,b,c,(:binary.first s),0,0} 
  end 

  def evalHand([{c, _}, {a, _}, {a, _}, {a, s}, {b, _}]) do
    {4,a,b,c,(:binary.first s),0,0}
  end

  def evalHand([{c, _}, {b, _}, {a, _}, {a, _}, {a, s}]) do 
    {4,a,b,c,(:binary.first s),0,0}
  end
  
  #conditions to check for two-pair
  def evalHand([{b, _}, {b, _}, {a, _}, {a, s}, {c, _}]) do 
    {3,a,b,c,(:binary.first s),0,0}
  end

  def evalHand([{b, _}, {b, _}, {c, _}, {a, _}, {a, s}]) do 
    {3,a,b,c,(:binary.first s),0,0}
  end

  def evalHand([{c, _}, {b, _}, {b, _}, {a, _}, {a, s}]) do 
    {3,a,b,c,(:binary.first s),0,0}
  end
  
  #conditions to check for pair
  def evalHand([{a, _}, {a, s}, {d, _}, {c, _}, {b, _}]) do 
    {2,a,b,c,d,(:binary.first s),0}
  end 
  
  def evalHand([{d, _}, {a, _}, {a, s}, {c, _}, {b, _}]) do 
    {2,a,b,c,d,(:binary.first s),0}
  end

  def evalHand([{d, _}, {c, _}, {a, _}, {a, s}, {b, _}]) do 
    {2,a,b,c,d,(:binary.first s),0}
  end

  def evalHand([{d, _}, {c, _}, {b, _}, {a, _}, {a, s}]) do 
    {2,a,b,c,d,(:binary.first s),0}
  end
  
  #conditions to check for high-card
  def evalHand([{e, _}, {d, _}, {c, _}, {b, _}, {a, s}]) do
    {1,a,b,c,d,e,(:binary.first s)}
  end 

end
