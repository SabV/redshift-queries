select *

	from	(select case
			when t.action_type = 'new_car_compliance' then 'NCC'
			when t.action_type = 'new_car_quality' then 'NCQ'
			when t.action_type = 'car_photo_quality' then 'CPQ'
			when t.action_type = 'avatar_quality' then 'UPQ'
			when t.action_type = 'suspicious_messages' then 'BS'
			when t.action_type = 'driver_vetting' then 'DV'
			when t.action_type = 'driver_vetting_urgent' then 'DVU'
			when t.action_type = 'license_issue_date_verification' then 'LID'
			end as todo_type,
			
			count(t.id), 
			
			case
			when (to_char(convert_timezone('Europe/Bucharest', t.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Bucharest', t.created_at), 'HH24') >= 21 and to_char(convert_timezone('Europe/Bucharest', t.created_at), 'IW') = 52) then 						to_char(dateadd(y, 1, convert_timezone('Europe/Bucharest', t.created_at)), 'YYYY')
			else to_char(convert_timezone('Europe/Bucharest', t.created_at), 'YYYY')
			end as year,
						
			case
			when (to_char(convert_timezone('Europe/Bucharest', t.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Bucharest', t.created_at), 'HH24') >= 21) then to_char(dateadd(w, 1, convert_timezone('Europe/Bucharest', t.created_at)), 'IW')
			when (to_char(convert_timezone('Europe/Bucharest', t.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Bucharest', t.created_at), 'HH24') >= 21 and to_char(convert_timezone('Europe/Bucharest', t.created_at), 'IW') = 52) then '01'
			else to_char(convert_timezone('Europe/Bucharest', t.created_at), 'IW')
			end as week
			
				from todos t
			
					where ((t.action_type in ('new_car_compliance', 'new_car_quality', 'car_photo_quality', 'avatar_quality', 'suspicious_messages', 'driver_vetting', 'driver_vetting_urgent', 'license_issue_date_verification') and t.country = 'FR')
					or (t.action_type in ('new_car_compliance', 'car_photo_quality', 'avatar_quality', 'driver_vetting', 'driver_vetting_urgent', 'license_issue_date_verification') and t.country in ('DE', 'ES', 'AT', 'BE')))
					
						group by year, week, t.action_type
						
							order by year, week,
							case
							when t.action_type = 'new_car_compliance' then '01'
							when t.action_type = 'new_car_quality' then '02'
							when t.action_type = 'car_photo_quality' then '03'
							when t.action_type = 'avatar_quality' then '04'
							when t.action_type = 'suspicious_messages' then '05'
							when t.action_type = 'driver_vetting' then '06'
							when t.action_type = 'driver_vetting_urgent' then '07'
							when t.action_type = 'license_issue_date_verification' then '08'
							end asc)t

		where year = 2017
		and week = ---
;
