select h.universal_id, to_char(convert_timezone('Europe/Paris', h.received_at), 'YYYY') as year, to_char(convert_timezone('Europe/Paris', h.received_at), 'MM') as month, to_char(convert_timezone('Europe/Paris', h.received_at), 'IW') as week

	from mapped_hits h

		where h.path like '/help/articles%'
		and to_char(convert_timezone('Europe/Paris', h.received_at), 'YYYY') = 2017
		and to_char(convert_timezone('Europe/Paris', h.received_at), 'IW') = ---

			group by h.universal_id, year, month, week

				order by week asc
;
