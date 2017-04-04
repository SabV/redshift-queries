select u.todo_type, count(distinct(u.id)),

case when u.backlog_year is null then '2017'

else u.backlog_year
end as this_year,

case when u.backlog_week is null then ' --- '

else u.backlog_week
end as last_week

	from	(select *
	
				from	(select case
						when t.action_type = 'new_car_compliance' then 'NCC'
						when t.action_type = 'new_car_quality' then 'NCQ'
						when t.action_type = 'car_photo_quality' then 'CPQ'
						when t.action_type = 'avatar_quality' then 'UPQ'
						when t.action_type = 'suspicious_messages' then 'BS'
						end as todo_type,
						
						t.id, tvn.version_week as new_week, tvn.version_year as new_year, tvc.version_week as closed_week, tvc.version_year as closed_year, tvc.backlog_week, tvc.backlog_year
						
							from todos t
							
							inner join	(select tv.id as version_id,
										
										case
										when (to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'HH24') >= 21 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 										'IW') = 52) then to_char(dateadd(y, 1, convert_timezone('Europe/Bucharest', tv.created_at)), 'YYYY')
										else to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'YYYY')
										end as version_year,
									
										case
										when (to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'HH24') >= 21 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 										'IW') < 52) then to_char(dateadd(w, 1, convert_timezone('Europe/Bucharest', tv.created_at)), 'IW')
										when (to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'HH24') >= 21 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 										'IW') = 52) then '01'
										else to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'IW')
										end as version_week,
										
										tv.item_id
										
											from todo_versions tv
										
												where tv.event = 'create')tvn on tvn.item_id = t.id
										
							left join	(select tv.id as version_id,
										
										case
										when (to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'HH24') >= 21 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 										'IW') = 52) then to_char(dateadd(y, 1, convert_timezone('Europe/Bucharest', tv.created_at)), 'YYYY')
										else to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'YYYY')
										end as version_year,
									
										case
										when (to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'HH24') >= 21) then to_char(dateadd(w, 1, convert_timezone('Europe/Bucharest', 										tv.created_at)), 'IW')
										when (to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'HH24') >= 21 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 										'IW') = 52) then '01'
										else to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'IW')
										end as version_week,
										
										case
										when (to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'HH24') >= 21) then to_char(convert_timezone('Europe/Bucharest', 														tv.created_at), 'IW')
										when (to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'HH24') < 21 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 											'IW') = '01') then '52'
										when (to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'D') <> 1 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'IW') = '01') then '52'
										else to_char(dateadd(w, -1, convert_timezone('Europe/Bucharest', tv.created_at)), 'IW')
										end as backlog_week,
										
										case
										when (to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'HH24') < 21 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 											'IW') = '01') then to_char(dateadd(y, -1, convert_timezone('Europe/Bucharest', tv.created_at)), 'YYYY')
										when (to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'D') <> 1 and to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'IW') = '01') then to_char(dateadd(y, -1, convert_timezone('Europe/Bucharest', 										tv.created_at)), 'YYYY')
										else to_char(convert_timezone('Europe/Bucharest', tv.created_at), 'YYYY')
										end as backlog_year,

										
										tv.item_id
										
											from todo_versions tv
										
												where tv.state_after = 'closed')tvc  on tvc.item_id = t.id
										
						
								where ((t.action_type in ('new_car_compliance', 'new_car_quality', 'car_photo_quality', 'avatar_quality', 'suspicious_messages') and t.country = 'FR')
								or (t.action_type in ('new_car_compliance', 'car_photo_quality', 'avatar_quality') and t.country in ('DE', 'ES', 'AT', 'BE'))))t
			
					where t.new_year = 2017
					
					and t.new_week <= ---
					
					and (t.closed_week is null or t.closed_week > t.new_week or t.closed_year > t.new_year)
					
					and (t.backlog_week is null or t.backlog_week = ---
					
					))u	
					
						group by u.todo_type, last_week, this_year
						
							order by
							case
							when u.todo_type = 'NCC' then '01'
							when u.todo_type = 'NCQ' then '02'
							when u.todo_type = 'CPQ' then '03'
							when u.todo_type = 'UPQ' then '04'
							when u.todo_type = 'BS' then '05'
							end asc
;
