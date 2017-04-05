select *

	from

	(select z.id, zg.name, a.first_name as agent, to_char(convert_timezone('Europe/Paris', z.created_at), 'MM') as month, 	to_char(convert_timezone('Europe/Paris', z.created_at), 'YYYY') as year

		from zendesk_tickets z
		left join zendesk_users zu on zu.id=z.submitter_id
		left join zendesk_users za on za.id=z.assignee_id
		left join zendesk_groups zg on zg.id = z.group_id
		left join users a on a.id=za.drivy_user_id

			where (zu.role = 'end-user' or zu.role='agent')

				order by z.created_at asc)t

	where t.year = 2017
	and t.month = ---
;
