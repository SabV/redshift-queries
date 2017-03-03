select d.*, a.first_name as agent, to_char(d.sent_at, 'YYYY') as year, to_char(d.sent_at, 'IW') as week, to_char(d.sent_at, 'MM') as month, to_char(d.sent_at, 'DD') as day

	from diduenjoy d

		left join zendesk_tickets z on d.zendesk_ticket_id=z.id
		left join zendesk_users za on za.id=z.assignee_id
		left join users a on a.id=za.drivy_user_id

			where to_char(d.sent_at, 'YYYY') = 2017
			and to_char(d.sent_at, 'IW') = ---

				order by d.sent_at asc