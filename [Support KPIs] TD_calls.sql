select t.id, t.call_type, t.start_time, t.end_time, t.talkdesk_phone_number, t.customer_phone_number, t.duration, t.record, t.hangup, t.in_business_hours, t.waiting_time, t.agent_speed_to_answer, t.holding_time, t.description, t.agent_name, t.phone_display_name, t.disposition_code, t.transferred, t.handling_agent, t.ivr_options, t.customer_drivy_id, t.country, to_char(t.start_time, 'DD') as day, to_char(t.start_time, 'IW') as week, to_char(t.start_time, 'MM') as month, to_char(t.start_time, 'YYYY') as year, u.behavior,

case when t.phone_display_name = 'FR Support' and left(t.ivr_options, 1) = '1' then 'CLAIMS'
when t.phone_display_name = 'FR Power & Pro Owners' and left(t.ivr_options, 1) = '1' then 'CLAIMS'
when t.phone_display_name = 'FR Webhelp > Accident' then 'CLAIMS'
when t.phone_display_name = 'FR Support' and left(t.ivr_options, 1) <> '1' then 'FR'
when t.phone_display_name = 'FR Support' and t.ivr_options is null then 'FR'
when t.phone_display_name = 'FR Open Support' then 'FR'
when t.phone_display_name = 'FR Owner' then 'FR'
when t.phone_display_name = 'FR Power & Pro Owners' then 'FR'
when t.phone_display_name = 'FR Power & Pro Owners' then 'FR'
when t.phone_display_name = 'FR Webhelp > Support' then 'FR'
when t.phone_display_name = 'DE Support' then 'DE-AT'
when t.phone_display_name = 'DE Open Support' then 'DE-AT'
when t.phone_display_name = 'DE Webhelp > Support' then 'DE-AT'
when t.phone_display_name = 'AT Support' then 'DE-AT'
when t.phone_display_name = 'DE Quality' then 'DE-AT'
when t.phone_display_name = 'ES Support' then 'ES'
when t.phone_display_name = 'ES Open Support' then 'ES'
when t.phone_display_name = 'BE Support' then 'BE'
else 'ELSE'
end as sc_country,

case when t.in_business_hours = TRUE
and t.agent_name ='If-No-Answer Agent'
and (t.phone_display_name = 'FR Support' or
(t.phone_display_name = 'FR LicenseCheck') or
(t.phone_display_name = 'FR Owner') or
(t.phone_display_name = 'DE Support' and t.ivr_options = '3') or
(t.phone_display_name = 'FR Power & Pro Owners' and left(t.ivr_options, 1) = '2'))
then 'Webhelp'
else 'Drivy'
end as organisation,

case when (t.call_type = 'outbound' or t.call_type = 'outbound_missed') then '0'
else '1'
end as inbound

	from talkdesk_calls t
	left join users u on t.customer_drivy_id=u.id

		where to_char(t.start_time, 'YYYY') = 2017
		and to_char(t.start_time, 'IW') = ---

			order by t.start_time asc