
CREATE TEMP TABLE temp_badges_import (  --временная таблица
    data text
);


INSERT INTO temp_badges_import VALUES 
('
<badges>
    <row /> -- формат дял внутриностей XML, просто вставить всё
</badges>
');


INSERT INTO Badges (Id, UserId, Name, Date, Class, TagBased)  --Собственно Insert
SELECT 
    (xpath('//row/@Id', xml_data))[1]::text::int,
    (xpath('//row/@UserId', xml_data))[1]::text::int,
    (xpath('//row/@Name', xml_data))[1]::text,
    (xpath('//row/@Date', xml_data))[1]::text::timestamp,
    (xpath('//row/@Class', xml_data))[1]::text::smallint,
    (xpath('//row/@TagBased', xml_data))[1]::text::boolean
FROM 
    (SELECT unnest(xpath('//badges/row', data::xml)) AS xml_data 
     FROM temp_badges_import) AS extracted_data;

