select registration_country,
ncc_average,
ncc_less_than_24,
ncc_more_than_24,
max(ncc_95th) as ncc_95th

	from (
	
	select registration_country,
	round(avg(time_to_ncc), 2) as ncc_average,
	round(count(case when time_to_ncc <= 24 then 1 end)::float/count(time_to_ncc)::float, 2) as ncc_less_than_24,
	round(count(case when time_to_ncc > 24 then 1 end)::float/count(time_to_ncc)::float, 2) as ncc_more_than_24,
	round(percentile_cont(0.95) within GROUP (order by time_to_ncc asc), 2) as ncc_95th
	
		from (
		
		select c.registration_country, round(datediff(min, c.created_at, t.closed_at)::float/60,2) as time_to_ncc
			
			from cars c
			inner join todos t on t.subject_id = c.id and t.action_type = 'new_car_compliance' and t.state= 'closed'
			left join todos q on q.subject_id = c.id and q.action_type = 'new_car_quality' and t.state = 'closed'
	
				where datediff(d, c.created_at, CURRENT_DATE) < 10)
	
					group by registration_country)
	
	group by registration_country, ncc_average, ncc_less_than_24, ncc_more_than_24