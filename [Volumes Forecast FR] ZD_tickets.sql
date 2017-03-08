select *

	from (	select to_char(convert_timezone('Europe/Paris', z.created_at), 'YYYY') as year, to_char(convert_timezone('Europe/Paris', z.created_at), 'IW') as week,

			case when z.group_id='26474785' then 'FR Flags'
			when z.group_id='26344589' then 'FR Level 1'
			end as groups,

			count(z.id)

				from zendesk_tickets z
				left join zendesk_users zs on zs.id = z.submitter_id
				left join zendesk_users za on za.id = z.assignee_id
				left join zendesk_ticket_metrics ztm on ztm.ticket_id = z.id
				left join users u on za.drivy_user_id = u.id
				left join team_memberships tm on u.id = tm.user_id


					where to_char(convert_timezone('Europe/Paris', z.created_at), 'YYYY') = 2017
					and ((z.group_id = '26474785' and zs.role = 'admin') or (z.group_id = '26344589' and zs.role = 'end-user'))
					and tm.name = 'external_support'
					and ztm.nb_replies is not null

						group by year, week, z.group_id)

	where week = ---
;
