=begin
This program prompts the user for the name of a text file which contains
an initial board. Validates the text file, then solves the Sodoku
problem and outputs the solved board.

author: Ronit Kumar
=end

@DIMENSION = 9
@PARTITION = 3
@INPUTFILE
@GAMEBOARD
@TESTVALS = [1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9]


# A helper method to indicate what row a certain index
# in the boardGame array falls on
# @param index
# @returns the row number (indexed at 0)
#
def indexToRow(index)
    rowmarker = 0
    i = 0
    while i<@DIMENSION
        if (index >= (@DIMENSION * i)) && (index < (@DIMENSION * (i+1)))
            rowmarker = i
            return rowmarker
        end
        i= i + 1
    end
return rowmarker
end

# A helper method to indicate the last index
# of a certain row is
# @param rownum
# @returns lastindex
#
def lastIndexInRow(rownum)
    lastindex = (((rownum+1) * @DIMENSION) - 1)
end

# Takes the inputted sudoku file and
# converts the data to a 1D array, replacing
# the '.' with 0s
#
def ParseBoard()
    input = File.open(@INPUTFILE, "r")
    @gameboard = [ ]
    @blankSpots = [ ]
    #cycle through all lines in the file
    input.each do |line|
        line.each_char do |c|
            if (1..9).member?(c.to_i)
                @gameboard << c.to_i
            end
            if c == '.'
                @gameboard << 0
            end
        end
    end

    # find blank spots
    @gameboard.each_with_index {|value, index|
        if value==0
            @blankSpots << index
        end
    }
  input.close
  @GAMEBOARD =  @gameboard
  return @gameboard, @blankSpots
end

# Ensure the board is always valid that is every row
# and column has no duplicates except 0s, and every
# @DIMENSION square has no duplicates except 0s
def validateBoard()
    #cycle through all lines in the file
    row = 0
    for row in 0..8
        # @gameboard index
        index = 0
        # array temp is used to store number appearing in the same row
        temp = Array.new
        # temp array index
        i = 0
        while index<@DIMENSION
            if (1..9).member? @gameboard[row * @DIMENSION + index]
                if temp.include? @gameboard[row * @DIMENSION + index]
                    return false
                else
                    temp[i] = @gameboard[row * @DIMENSION + index]
                    i += 1
                end
            end
            index += 1
        end
    end
    #cycle through all columns in the file
    column = 0
    for column in 0..8
        # @gameboard index
        index = 0
        # array temp is used to store number appearing in the same row
        temp = Array.new
        # temp array index
        i = 0
        while index<@DIMENSION
            if (1..9).member? @gameboard[column + index  * @DIMENSION]
                if temp.include? @gameboard[column+ index * @DIMENSION]
                    return false
                else
                    temp[i] = @gameboard[column+ index * @DIMENSION]
                    i += 1
                end
            end
            index += 1
        end
    end
    #cycle through all @DEIMENSION squares in the file
    startIndex = 0
    rowBase = 0
    columnBase = 0
    for rowBase in 0..2
        startIndex = rowBase * 3 * @DIMENSION
        for columnBase in 0..2
            # array temp is used to store number appearing in the same row
            temp = Array.new
            # temp array index
            i = 0
            #find the real index in @gameboard
            l = 0
            for l in 0..2
                m = 0
                for m in 0..2
                    index = startIndex + m * @DIMENSION + l
                    if (1..9).member? @gameboard[index]
                        if temp.include? @gameboard[index]
                            return false
                            else
                            temp[i] = @gameboard[index]
                            i += 1
                        end
                    end
                end
            end
            startIndex += 3
        end
    end
    return true
end

# Use backtracking algorithm to slove sudoku
def backtrackingSolver()
    size = @blankSpots.size
    index = 0
    while index < size
        @gameboard[@blankSpots[index]] += 1
        if @gameboard[@blankSpots[index]] > 9
            @gameboard[@blankSpots[index]] = 0
            index -= 1
        elsif validateBoard()
            index += 1
        end
    end
end

# Ensure the board has @@DIMENSION data cells in each row
# and that there are @@DIMENSION data rows
#
def ValidateInput(input)
    #cycle through all lines in the file
    row = 1
    input.each do |line|
        dataCellsPerRow = 0
        line.each_char do |c|
            #count . or number 1-9
            if c == '.'
                dataCellsPerRow = dataCellsPerRow + 1
            end
            if (1..9).member?(c.to_i)
               dataCellsPerRow = dataCellsPerRow + 1
            end
        end
        if (dataCellsPerRow != @DIMENSION) && (row%(@PARTITION + 1) != 0)
            puts "Improper data formatting in Sudoku file"
            exit
        end
        row = row + 1
    end
end


# Prints the current @gameboard
#
def PrintBoard()
    input = File.open(@INPUTFILE, "r")
    #cycle through all lines in the file
    row = 1
    blankCount = 0
    input.each do |line|
        line.each_char do |c|
            #count . or number 1-9
            if c == '.'
                c = @gameboard[@blankSpots[blankCount]]
                blankCount = blankCount + 1
            end
            print c.to_s
        end
        row = row + 1
    end
    print "\n\n______________________________________\n"
end

# ====== MAIN ===========
# prompt user for file
print "Enter the Sudoku filename: "
@INPUTFILE = gets.chomp()

# take in file
begin
    input = File.open(@INPUTFILE, "r")
    # uncomment the line below for testing
    # input = File.open("sudoku/testInput.txt", "r")
rescue
    print <<INPUTTEXT
    Filename was entered incorrectly.(Example: sudoku/testInput.txt)
    Enter the Sudoku filename:
INPUTTEXT
    @INPUTFILE = gets.chomp()
    retry
end

ValidateInput(input)
#uncomment the below for testing
#@INPUTFILE = "sudoku/testInput.txt"
ParseBoard()
#puts "the size of gameboard is " + @gameboard.size.to_s
#puts "the number of blank spots is " + @blankSpots.size.to_s
PrintBoard()
#puts "what row is this index: " + indexToRow(36).to_s
## note 2 is the 3rd row
#puts "last index in row: " + lastIndexInRow(2).to_s

#puts @gameboard[80]
#puts(validateBoard)


puts "######### Solution #########"

backtrackingSolver()
PrintBoard()

