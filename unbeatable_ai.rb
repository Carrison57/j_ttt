class UnbeatableAI

	attr_accessor :marker

	def initialize(marker)
		@marker = marker
	end

	def get_move(ttt_board)
		cpu_marker = marker
		
		if cpu_marker == "O"
			player_marker = "X"
		else
			player_marker = "O"
		end

		if check_for_win(ttt_board, cpu_marker) <= 8
			move = check_for_win(ttt_board, cpu_marker)
			move = move + 1
		elsif check_for_block(ttt_board, player_marker) <= 8
			move = check_for_block(ttt_board, player_marker)
			move = move + 1
		elsif check_for_fork(ttt_board) <= 8
			move = check_for_fork(ttt_board)
			move = move + 1
		elsif block_opponents_fork(ttt_board, cpu_marker) <= 8
			move = block_opponents_fork(ttt_board, cpu_marker)
			move = move + 1
		elsif check_for_center(ttt_board) <= 8
			move = check_for_center(ttt_board)
			move = move + 1
		elsif opponent_corner(ttt_board) <= 8
			move = opponent_corner(ttt_board)
			move = move + 1
		elsif check_empty_corner(ttt_board) <= 8
			move = check_empty_corner(ttt_board)
			move = move + 1
		elsif check_empty_side(ttt_board) <=8
			move = check_empty_side(ttt_board)
			move = move + 1
		else
			move = ttt_board.index(" ")
		end
		move
	end

	def check_for_win(ttt_board, your_marker)
		win_or_block(ttt_board, your_marker)
	end

	def check_for_block(ttt_board, player_marker)
		win_or_block(ttt_board, player_marker)
	end

	def win_or_block(ttt_board, current_marker)
		winning_or_block_combinations = [
							[ttt_board[0],ttt_board[1],ttt_board[2]],
							[ttt_board[3],ttt_board[4],ttt_board[5]],
							[ttt_board[6], ttt_board[7], ttt_board[8]],
							[ttt_board[0], ttt_board[3], ttt_board[6]],
							[ttt_board[1],ttt_board[4], ttt_board[7]],
							[ttt_board[2],ttt_board[5],ttt_board[8]], 
							[ttt_board[0], ttt_board[4], ttt_board[8]],
							[ttt_board[2],ttt_board[4],ttt_board[6]]
							]

		win_or_block_positions = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

		move = 10
		
		winning_or_block_combinations.each_with_index do |win_or_block_line, index|
			if win_or_block_line.count(current_marker) == 2 && win_or_block_line.count(" ") == 1
				winner_or_block = win_or_block_line.index(" ")
				i = index
				move = win_or_block_positions[i][winner_or_block]
			end
		end
		move
	end

	def check_for_fork(ttt_board)
		fork_combinations = [
							[ttt_board[0],ttt_board[1],ttt_board[2]],
							[ttt_board[3],ttt_board[4],ttt_board[5]],
							[ttt_board[6], ttt_board[7], ttt_board[8]],
							[ttt_board[0], ttt_board[3], ttt_board[6]],
							[ttt_board[1],ttt_board[4], ttt_board[7]],
							[ttt_board[2],ttt_board[5],ttt_board[8]], 
							[ttt_board[0], ttt_board[4], ttt_board[8]],
							[ttt_board[2],ttt_board[4],ttt_board[6]]
							]

		fork_positions = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

		fork_line = []
		fork_spot = []
		i = []
		
		fork_combinations.each_with_index do |forking_line, index|
			if forking_line.count(marker) == 1 && forking_line.count(" ") == 2
				fork_line = forking_line
				i.push(index)
			end
		end

		i.each do |index|
			fork_spot.push(fork_positions[index])
		end

		fork_spot = fork_spot.flatten.sort

		conditional_array = []
		fork_spot.each do |spot|
			if ttt_board[spot] == " "
				conditional_array.push(spot)
			end
		end

		if conditional_array.detect { |match| conditional_array.count(match) > 1 } == nil
			move = 10
		else
			move = conditional_array.detect { |match| conditional_array.count(match) > 1 }
		end
		move
	end

	def block_opponents_fork(ttt_board, cpu_marker)
		block_fork_combinations = [
								[ttt_board[0],ttt_board[1],ttt_board[2]],
								[ttt_board[3],ttt_board[4],ttt_board[5]],
								[ttt_board[6], ttt_board[7], ttt_board[8]],
								[ttt_board[0], ttt_board[3], ttt_board[6]],
								[ttt_board[1],ttt_board[4], ttt_board[7]],
								[ttt_board[2],ttt_board[5],ttt_board[8]], 
								[ttt_board[0], ttt_board[4], ttt_board[8]],
								[ttt_board[2],ttt_board[4],ttt_board[6]]
								]

		block_fork_positions = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

		if cpu_marker == "O"
			player_marker = "X"
		else
			player_marker = "O"
		end

		block_fork_line = []
		block_fork_spot = []
		i = []
		
		block_fork_combinations.each_with_index do |block_forking_line, index|
			if block_forking_line.count(player_marker) == 1 && block_forking_line.count(" ") == 2
				block_fork_line = block_forking_line
				i.push(index)
			end
		end

		i.each do |index|
			block_fork_spot.push(block_fork_positions[index])
		end

		block_fork_spot = block_fork_spot.flatten.sort

		block_spot = []

		if block_fork_spot.include?(4)
			move = 10
		else
			block_fork_spot.each do |spot|
				if ttt_board[spot] == "X" && ttt_board[spot + 1] == " "
					block_spot.push(spot + 1)
				else
					move = 10
				end
			end
		end

		if block_spot == []
			move = 10
		else
			move = block_spot.shift
		end

		move
	end

	def check_for_center(ttt_board)
		if ttt_board[4] == " "
			move = 4
		else
			move = 10
		end
	end

	def opponent_corner(ttt_board)
		cpu_marker = marker
		
		if cpu_marker == "O"
			player_marker = "X"
		else
			player_marker = "O"
		end

		if ttt_board[0] == player_marker && ttt_board[8] == " "
			move = 8
		elsif ttt_board[2] == player_marker && ttt_board[6] == " "
			move = 6
		elsif ttt_board[6] == player_marker && ttt_board[2] == " "
			move = 2
		elsif ttt_board[8] == player_marker && ttt_board[0] == " "
			move = 0
		else
			move = 10
		end
		move
	end

	def check_empty_corner(ttt_board)
		if ttt_board[0] == " "
			move = 0
		elsif ttt_board[2] == " "
			move = 2
		elsif ttt_board[6] == " "
			move = 6
		elsif ttt_board[8] == " "
			move = 8
		else
			move = 10
		end
	end

	def check_empty_side(ttt_board)
		sides = [1, 3, 5, 7]
		side_options = []

		sides.each do |side|
			if ttt_board[side] == " "
				side_options.push(side)
			end
		end
		first_side_available = side_options.shift
	end

end

# class UnbeatableAI
# 	attr_accessor :marker

# 	def initialize(marker)
# 		@marker = marker
# 	end

# 	def get_move(ttt_board)
# 		your_marker = marker
		
# 		if your_marker == "X"
# 			opponent_marker = "O"
# 		else
# 			opponent_marker = "X"
# 		end

# 		if check_for_win(ttt_board, your_marker) <= 8
# 			move = check_for_win(ttt_board, your_marker)
# 		elsif check_for_block(ttt_board, opponent_marker) <= 8
# 			move = check_for_block(ttt_board, opponent_marker)
# 		else
# 			move = ttt_board.index(" ")
# 		end
# 		move
# 	end

# 	def win_or_block(ttt_board, current_marker)
# 		winning_or_block_combinations = [
# 							[ttt_board[0],ttt_board[1],ttt_board[2]],
# 							[ttt_board[3],ttt_board[4],ttt_board[5]],
# 							[ttt_board[6], ttt_board[7], ttt_board[8]],
# 							[ttt_board[0], ttt_board[3], ttt_board[6]],
# 							[ttt_board[1],ttt_board[4], ttt_board[7]],
# 							[ttt_board[2],ttt_board[5],ttt_board[8]], 
# 							[ttt_board[0], ttt_board[4], ttt_board[8]],
# 							[ttt_board[2],ttt_board[4],ttt_board[6]]
# 							]

# 		win_or_block_positions = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

# 		pick = 10
		
# 		winning_or_block_combinations.each_with_index do |win_or_block_line, index|
# 			if win_or_block_line.count(current_marker) == 2 && win_or_block_line.count(" ") == 1
# 				winner_or_block = win_or_block_line.index(" ")
# 				i = index
# 				pick = win_or_block_positions[i][winner_or_block]
# 			end
# 		end
# 		pick
# 	end

# 	def check_for_win(ttt_board, your_marker)
# 		win_or_block(ttt_board, your_marker)
# 	end

# 	def check_for_block(ttt_board, opponent_marker)
# 		win_or_block(ttt_board, opponent_marker)
# 	end

# 	def check_for_fork(ttt_board)
# 		fork_combinations = [
# 							[ttt_board[0],ttt_board[1],ttt_board[2]],
# 							[ttt_board[3],ttt_board[4],ttt_board[5]],
# 							[ttt_board[6], ttt_board[7], ttt_board[8]],
# 							[ttt_board[0], ttt_board[3], ttt_board[6]],
# 							[ttt_board[1],ttt_board[4], ttt_board[7]],
# 							[ttt_board[2],ttt_board[5],ttt_board[8]], 
# 							[ttt_board[0], ttt_board[4], ttt_board[8]],
# 							[ttt_board[2],ttt_board[4],ttt_board[6]]
# 							]

# 		fork_positions = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

# 		fork_line = []
# 		fork_spot = []
# 		i = []
# 		i2 = 0
		
# 		fork_combinations.each_with_index do |forking_line, index|
# 			if forking_line.count(marker) == 1 && forking_line.count(" ") == 2
# 				fork_line = forking_line
# 				i.push(index)
# 			end
# 		end

# 		i.each do |index|
# 			fork_spot.push(fork_positions[index])
# 		end

# 		fork_spot = fork_spot.flatten

# 		fork_spot.detect { |match| fork_spot.count(match) > 1}
# 	end
# end