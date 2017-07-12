SELECT count(distinct(id)), 'Tickets' as action_type,
          year_month
   FROM
     (SELECT CASE WHEN g.id IN ('26344589',
                                '26474785') THEN 'FR' ELSE 'ELSE' END AS country,
                                                                                                                                                                                        date_trunc('month', convert_timezone('Europe/Paris', c.created_at)) AS year_month, c.id
	
	FROM zendesk_ticket_comments c
      INNER JOIN zendesk_tickets t ON t.id = c.ticket_id
      INNER JOIN zendesk_groups g ON g.id = t.group_id
      LEFT JOIN
(SELECT *
 FROM zendesk_ticket_tags zz
 WHERE zz.tag_name LIKE '%rental_flag%'
   OR zz.tag_name LIKE '%match_flag%'
   OR zz.tag_name LIKE '%car_flag%'
   OR zz.tag_name LIKE '%rental_message_flag%'
   OR zz.tag_name LIKE '%rental_message_flags%'
   OR zz.tag_name LIKE '%car_deactivation%'
   OR zz.tag_name LIKE '%sms_failure%'
   OR zz.tag_name LIKE '%car_flags%'
   OR zz.tag_name LIKE '%open_checkin_checkout%'
 GROUP BY zz.tag_name,
          zz.ticket_id)zt ON zt.ticket_id=t.id
      INNER JOIN zendesk_users zu ON zu.id = c.author_id
      INNER JOIN users u ON zu.drivy_user_id = u.id
      LEFT JOIN team_memberships tm ON tm.user_id = u.id
WHERE zu.role IN ('agent',
                  'admin')
AND zt.ticket_id IS NULL
AND c.is_public IS TRUE
AND tm.name IN ('external_support', 'external_quality')
      GROUP BY c.id,
               g.id,
               c.created_at,
               tm.name, u.first_name, u.last_name, u.id)
WHERE country <> 'ELSE'
AND year_month = date_trunc('month', dateadd(month, -1, convert_timezone('Europe/Paris', CURRENT_DATE)))

GROUP BY country,
          year_month

UNION ALL

select sum(count) as count, action_type, year_month

	from (
	
	--- CLOSED BY THEM
	
			select action_type, count, year_month
			
				from 	(select t.agent,
					
						case when t.action_type = 'bad_pricing' then 'BP'
						when t.action_type = 'new_owner_onboarding' then 'OOB'
						when t.action_type = 'car_model_change' then 'CMC'
						else t.action_type
						end as action_type,
						
						count(distinct(t.id)) as count, t.year_month
						
							from	(select t.id, case when u.first_name = 'Andreea' then u.first_name || ' ' || left(u.last_name, 1) else u.first_name end as agent, t.action_type, date_trunc('month', convert_timezone('Europe/Paris', t.closed_at)) as year_month						
										from todos t
										inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'closed'
										inner join users u on u.id = e.whodunnit
										inner join team_memberships tm on tm.user_id = e.whodunnit and tm.name = 'external_quality'
						
											where t.action_type in ('bad_pricing', 'new_owner_onboarding', 'car_model_change') and t.country = 'FR'
											
											and t.state='closed'
			
												group by u.first_name, u.last_name, e.created_at, t.closed_at, t.action_type, t.id)t
						
									group by t.agent, t.action_type, t.year_month)u
						
where year_month = date_trunc('month', dateadd(month, -1, convert_timezone('Europe/Paris', CURRENT_DATE))) 
	
UNION
	
	--- CLOSED BY US - ASSIGNED BY THEM
	
			select action_type, count, year_month
			
				from 	(select t.agent,
					
						case when t.action_type = 'bad_pricing' then 'BP'
						when t.action_type = 'new_owner_onboarding' then 'OOB'
						when t.action_type = 'car_model_change' then 'CMC'
						else t.action_type
						end as action_type,
						
						
						count(distinct(t.id)) as count, t.year_month
						
							from	(select t.id, case when u.first_name = 'Andreea' then u.first_name || ' ' || left(u.last_name, 1) else u.first_name end as agent, t.action_type, date_trunc('month', convert_timezone('Europe/Paris', t.closed_at)) as year_month
						
										from todos t
										inner join todo_versions g on g.item_id = t.id and g.state_before = 'going' and g.state_after = 'going'
										inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'closed'
										inner join users u on u.id = g.whodunnit
										inner join users uc on uc.id = g.user_id_after and uc.is_admin = 1
										inner join team_memberships tm on tm.user_id = g.whodunnit and tm.name = 'external_quality'
						
											where t.action_type in ('bad_pricing', 'new_owner_onboarding', 'car_model_change') and t.country = 'FR'
											
											and t.state='closed'
			
												group by u.first_name, u.last_name, e.created_at, t.closed_at, t.action_type, t.id)t
						
									group by t.agent, t.action_type, t.year_month)u
						
where year_month = date_trunc('month', dateadd(month, -1, convert_timezone('Europe/Paris', CURRENT_DATE))) 

					)f
		group by action_type, year_month