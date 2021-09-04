##########
# Number Place (SUDOKU)
##########

# コマンドライン引数に指定されたファイルから盤を作成
if length(ARGS) == 0
    strInFile = "./npdata1.txt"
else
    strInFile = ARGS[1]
end
s = readlines(strInFile)
# print(s)

board = zeros(Int, 9, 9)

for i in 1:length(s)
    r = split(s[i])
    for j in 1:length(r)
        board[i,j] = parse(Int, r[j])
    end
end

# 関数定義ブロック

function print_board()
    print('\n')
    for i in 1:9
        print(board[i,1:9])
        print('\n')
    end
end

print('\n')
print_board()

# 空きマスがあるか
function find_empty()
    for i in 1:9
        for j in 1:9
            if board[i,j] == 0
                return (i, j)
            end
        end
    end
    return (0, 0)
end

# 空きマスに入れる値の候補
function find_choices(x::Int, y::Int)
    can_use = [1,2,3,4,5,6,7,8,9]

    # 同じ行に同じ値を入れられない
    for j in 1:9
        if board[x,j] > 0
            # deleteat!(can_use, findin(can_use, board[x,j]))
            filter!(v -> v != board[x,j], can_use)
        end
    end

    # 同じ列に同じ値を入れられない
    for i in 1:9
        if board[i,y] > 0
            filter!(v -> v != board[i,y], can_use)
        end
    end

    # 同じブロックに同じ値を入れられない（cx,cyはブロックの中心）
    cx = Int8(ceil(x / 3)) * 3 - 1
    cy = Int8(ceil(y / 3)) * 3 - 1
    for i in (cx - 1):(cx + 1)
        for j in (cy - 1):(cy + 1)
            if board[i,j] > 0
                filter!(v -> v != board[i,j], can_use)
            end
        end
    end
    
    return can_use
end

# 値のセット
function put_val(x::Int, y::Int, v::Int)
    board[x, y] = v
end

# 値のクリア
function reset_val(x::Int, y::Int)
    put_val(x, y, 0)
end

# 解法コア（再帰＋バックトラッキング）
function dfs()
    
    x, y = find_empty()

    if x == 0 & y == 0
        print_board()
        return
    else
        can_use = find_choices(x, y)
        for v in can_use
            put_val(x, y, v)
            dfs()
            reset_val(x, y)
        end
    end
end

# Main
dfs()


