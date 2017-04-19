select count(1)

from rentals

where to_char(convert_timezone('Europe/Paris', ends_at), 'IW') = ---
and to_char(convert_timezone('Europe/Paris', ends_at), 'YYYY') = 2017
and state = 'ended'

group by to_char(convert_timezone('Europe/Paris', ends_at), 'IW')
