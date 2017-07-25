select bo_link, outcome
from ((select 'https://www.drivy.com/admin/todos/' || t.id as bo_link, t.action_type, c.category::text as outcome
						
										from todos t
										inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'closed'
										inner join users u on u.id = e.whodunnit
										inner join team_memberships tm on tm.user_id = e.whodunnit and tm.name = 'external_quality'
										inner join cars c on c.id = t.subject_id
						
											where t.action_type in ('new_car_compliance')
											and t.state = 'closed'
											and date_trunc('week', convert_timezone('Europe/Bucharest', t.closed_at)) = dateadd(w, -1, date_trunc('week', convert_timezone('Europe/Bucharest', current_date)))
order by random()
limit 10)
											
UNION ALL

(select 'https://www.drivy.com/admin/todos/' || t.id as bo_link, t.action_type, pv.state::text as outcome
						
										from todos t
										inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'closed'
										inner join users u on u.id = e.whodunnit
										inner join team_memberships tm on tm.user_id = e.whodunnit and tm.name = 'external_quality'
										inner join profile_verifications pv on pv.id = t.subject_id
						
											where t.action_type in ('driver_vetting', 'driver_vetting_urgent')
											and t.state = 'closed'
											and date_trunc('week', convert_timezone('Europe/Bucharest', t.closed_at)) = dateadd(w, -1, date_trunc('week', convert_timezone('Europe/Bucharest', current_date)))
order by random()
limit 10)

UNION ALL

(select 'https://www.drivy.com/admin/todos/' || t.id as bo_link, t.action_type, cp.quality::text as outcome
						
										from todos t
										inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'closed'
										inner join users u on u.id = e.whodunnit
										inner join team_memberships tm on tm.user_id = e.whodunnit and tm.name = 'external_quality'
										inner join car_photos cp on cp.id= t.subject_id
						
											where t.action_type in ('car_photo_quality')
											and t.state = 'closed'
											and date_trunc('week', convert_timezone('Europe/Bucharest', t.closed_at)) = dateadd(w, -1, date_trunc('week', convert_timezone('Europe/Bucharest', current_date)))
order by random()
limit 10)

order by action_type desc)
