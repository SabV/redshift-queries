SELECT count(distinct(c.id)), 'Tickets' as action_type, date_trunc('week', convert_timezone('Europe/Paris', c.created_at)) as year_week

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
GROUP BY zz.tag_name, zz.ticket_id)zt ON zt.ticket_id=t.id

INNER JOIN zendesk_users zu ON zu.id = c.author_id
LEFT JOIN team_memberships tm ON tm.user_id = zu.drivy_user_id

WHERE zu.role IN ('agent', 'admin')
AND zt.ticket_id IS NULL
AND c.is_public IS TRUE
AND tm.name IN ('external_support', 'external_quality')
AND g.id IN ('26344589', '26474785')
AND date_trunc('week', convert_timezone('Europe/Paris', c.created_at)) = dateadd(w, -1, date_trunc('week', convert_timezone('Europe/Paris', CURRENT_DATE)))

GROUP BY year_week

UNION ALL

select sum(count) as count, action_type, year_week

from (select count(distinct(t.id)),

case when t.action_type = 'bad_pricing' then 'BP'
when t.action_type = 'new_owner_onboarding' then 'OOB'
when t.action_type = 'car_model_change' then 'CMC'
when t.action_type = 'open_owner_lead' then 'OOL'
when t.action_type = 'new_open_owner_onboarding' then 'OPB'
when t.action_type = 'first_open_rental_owner_onboarding' then 'OFR'
when t.action_type = 'open_rental_overdue_checkout' then 'OVD'
else t.action_type
end as action_type,

date_trunc('week', convert_timezone('Europe/Paris', t.closed_at)) as year_week

from todos t
inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'closed'
inner join team_memberships tm on tm.user_id = e.whodunnit and tm.name in ('external_support', 'external_quality')
						
where t.action_type in ('bad_pricing', 'new_owner_onboarding', 'car_model_change', 'open_owner_lead', 'new_open_owner_onboarding', 'first_open_rental_owner_onboarding', 'open_rental_overdue_checkout') and t.country = 'FR'
and date_trunc('week', convert_timezone('Europe/Paris', t.closed_at)) = dateadd(w, -1, date_trunc('week', convert_timezone('Europe/Paris', CURRENT_DATE)))					
and t.state='closed'
			
group by action_type, year_week
						
UNION ALL
	
select count(distinct(t.id)),

case when t.action_type = 'bad_pricing' then 'BP'
when t.action_type = 'new_owner_onboarding' then 'OOB'
when t.action_type = 'car_model_change' then 'CMC'
when t.action_type = 'open_owner_lead' then 'OOL'
when t.action_type = 'new_open_owner_onboarding' then 'OPB'
when t.action_type = 'first_open_rental_owner_onboarding' then 'OFR'
when t.action_type = 'open_rental_overdue_checkout' then 'OVD'
else t.action_type
end as action_type,

date_trunc('week', convert_timezone('Europe/Paris', t.closed_at)) as year_week

from todos t
inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'going'
inner join todo_versions g on g.item_id = t.id and g.state_before = 'going' and g.state_after = 'closed'
inner join team_memberships tm on tm.user_id = e.whodunnit and tm.name in ('external_support', 'external_quality')
						
where t.action_type in ('bad_pricing', 'new_owner_onboarding', 'car_model_change', 'open_owner_lead', 'new_open_owner_onboarding', 'first_open_rental_owner_onboarding', 'open_rental_overdue_checkout') and t.country = 'FR'
and date_trunc('week', convert_timezone('Europe/Paris', t.closed_at)) = dateadd(w, -1, date_trunc('week', convert_timezone('Europe/Paris', CURRENT_DATE)))
and t.state='closed'
and g.whodunnit <> e.whodunnit
			
group by action_type, year_week)
group by action_type, year_week
