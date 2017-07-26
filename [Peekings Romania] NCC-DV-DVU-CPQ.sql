select year, week,
case when action_type = 'new_car_compliance' then 'NCC'
when action_type in ('driver_vetting', 'driver_vetting_urgent') then 'DV/DVU'
when action_type = 'car_photo_quality' then 'CPQ'
when action_type = 'avatar_quality' then 'UPQ'
end as action_type, bo_link, outcome, agent
from ((select 'https://www.drivy.com/admin/todos/' || t.id as bo_link, t.action_type, c.category::text as outcome, u.first_name || ' ' || u.last_name as agent, to_char(t.closed_at, 'YYYY') as year, to_char(t.closed_at, 'IW') as week
						
										from todos t
										inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'closed'
										inner join users u on u.id = e.whodunnit
										inner join team_memberships tm on tm.user_id = e.whodunnit and tm.name = 'external_quality'
										inner join cars c on c.id = t.subject_id
						
											where t.action_type in ('new_car_compliance')
											and t.state = 'closed'
											and date_trunc('week', convert_timezone('Europe/Bucharest', t.closed_at)) = dateadd(w, -1, date_trunc('week', convert_timezone('Europe/Bucharest', current_date)))
order by random()
limit 20)
											
UNION ALL

(select 'https://www.drivy.com/admin/todos/' || t.id as bo_link, t.action_type, pv.state::text as outcome, u.first_name || ' ' || u.last_name as agent, to_char(t.closed_at, 'YYYY') as year, to_char(t.closed_at, 'IW') as week
						
										from todos t
										inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'closed'
										inner join users u on u.id = e.whodunnit
										inner join team_memberships tm on tm.user_id = e.whodunnit and tm.name = 'external_quality'
										inner join profile_verifications pv on pv.id = t.subject_id and pv.verification_type ='onfido'
						
											where t.action_type in ('driver_vetting', 'driver_vetting_urgent')
											and t.state = 'closed'
											and date_trunc('week', convert_timezone('Europe/Bucharest', t.closed_at)) = dateadd(w, -1, date_trunc('week', convert_timezone('Europe/Bucharest', current_date)))
order by random()
limit 20)

UNION ALL

(select 'https://www.drivy.com/admin/todos/' || t.id as bo_link, t.action_type, cp.quality::text as outcome, u.first_name || ' ' || u.last_name as agent, to_char(t.closed_at, 'YYYY') as year, to_char(t.closed_at, 'IW') as week
						
										from todos t
										inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'closed'
										inner join users u on u.id = e.whodunnit
										inner join team_memberships tm on tm.user_id = e.whodunnit and tm.name = 'external_quality'
										inner join car_photos cp on cp.id= t.subject_id
						
											where t.action_type in ('car_photo_quality')
											and t.state = 'closed'
											and date_trunc('week', convert_timezone('Europe/Bucharest', t.closed_at)) = dateadd(w, -1, date_trunc('week', convert_timezone('Europe/Bucharest', current_date)))
order by random()
limit 20)

UNION ALL

(select case when uv.object_changes like '%.jpg", null]%' then 'https://drivy.imgix.net/uploads/originals/' || split_part(split_part(uv.object_changes, '/uploads/originals/', 2), '.jpg', 1) || '.jpg'
when uv.object_changes like '%.jpeg", null]%' then 'https://drivy.imgix.net/uploads/originals/' || split_part(split_part(uv.object_changes, '/uploads/originals/', 2), '.jpeg', 1) || '.jpeg'
when uv.object_changes like '%.png", null]%' then 'https://drivy.imgix.net/uploads/originals/' || split_part(split_part(uv.object_changes, '/uploads/originals/', 2), '.png', 1) || '.png'
when uv.id is null and av.object_changes like '%.jpeg%' then 'https://drivy.imgix.net/uploads/originals/' || split_part(split_part(av.object_changes, '/uploads/originals/', 2), '.jpeg', 1) || '.jpeg'
when uv.id is null and av.object_changes like '%.jpg%' then 'https://drivy.imgix.net/uploads/originals/' || split_part(split_part(av.object_changes, '/uploads/originals/', 2), '.jpg', 1) || '.jpg'
when uv.id is null and av.object_changes like '%.png%' then 'https://drivy.imgix.net/uploads/originals/' || split_part(split_part(av.object_changes, '/uploads/originals/', 2), '.png', 1) || '.png'
end as bo_link,

t.action_type, case when uv.id is null then 'accepted' else 'rejected' end as outcome, u.first_name || ' ' || u.last_name as agent, to_char(t.closed_at, 'YYYY') as year, to_char(t.closed_at, 'IW') as week
						
										from todos t
										inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'closed'
										inner join users u on u.id = e.whodunnit
										inner join team_memberships tm on tm.user_id = e.whodunnit and tm.name = 'external_quality'
										inner join users a on a.id= t.subject_id
										left join user_versions uv on a.id = uv.item_id and uv.whodunnit = u.id and uv.created_at > dateadd(s, -2, t.closed_at) and uv.created_at < dateadd(s, 2, t.closed_at)
										left join user_versions av on a.id = av.item_id and av.created_at > dateadd(s, -2, t.created_at) and av.created_at < dateadd(s, 2, t.created_at)


						
											where t.action_type in ('avatar_quality')
											and t.state = 'closed'
											and date_trunc('week', convert_timezone('Europe/Bucharest', t.closed_at)) = dateadd(w, -1, date_trunc('week', convert_timezone('Europe/Bucharest', current_date)))
order by random()
limit 20)

order by action_type desc)
