module Buffer exposing (..)

-- Buffer


type alias Buffer =
    List Char


empty : Buffer
empty =
    []


append : Char -> Buffer -> Buffer
append c b =
    c :: b


rstrip : Char -> Buffer -> Buffer
rstrip c b =
    case b of
        h :: t ->
            if h == c then
                rstrip c t
            else
                b

        b ->
            b


toString : Buffer -> String
toString =
    List.reverse >> String.fromList


length : Buffer -> Int
length =
    List.length


take : Int -> Buffer -> Buffer
take =
    List.take


isEmpty : Buffer -> Bool
isEmpty =
    List.isEmpty


drop : Int -> Buffer -> Buffer
drop =
    List.drop
