select *

	from (	select case when to_char(z.created_at, 'D') in (6,7,1) and to_char(dateadd(week, 1, z.created_at), 'IW') > 52 then
			to_char(dateadd(year,1,z.created_at), 'YYYY')
			else to_char(z.created_at, 'YYYY')
			end as year,

			case when to_char(z.created_at, 'D') in (6,7,1) and to_char(dateadd(week, 1, z.created_at), 'IW') <= 52 then to_char(dateadd(week, 1, z.created_at), 'IW')
			when to_char(z.created_at, 'D') in (6,7,1) and to_char(dateadd(week, 1, z.created_at), 'IW') > 52 then '01'
			else to_char(z.created_at, 'IW')
			end as week,

			case when z.group_id='26474785' then 'FR Flags'
			when z.group_id='26344589' then 'FR Level 1'
			end as groups,

			count(z.id)

				from zendesk_tickets z
				left join zendesk_users zs on zs.id = z.submitter_id
				left join zendesk_users za on za.id = z.assignee_id
				left join zendesk_ticket_metrics ztm on ztm.ticket_id = z.id
				left join users u on za.drivy_user_id = u.id

					where to_char(z.created_at, 'yyyy') = ---
					and z.group_id in (26474785, 26344589)
					and (zs.role = 'end-user' or zs.role = 'agent')
					and za.drivy_user_id in (931235, 931242, 1070381, 1221617, 1255079, 1257979, 1286202, 1287216, 1287255, 931231, 931238, 1070378, 1209360, 1255070, 1255085, 1284859, 1286222, 1287235, 1287266)
					and ztm.nb_replies is not null

						group by year, week, z.group_id)

	where week = ---