SELECT
"broadcasts"."id"                        AS id,
"broadcasts"."title"                     AS title,
COUNT("impressions"."id")                AS impressions,
AVG("impressions"."response")            AS approval,
AVG("impressions"."amount")              AS average,
coalesce(SUM("impressions"."amount"), 0) AS total,
coalesce(COUNT("impressions"."id") * (SELECT avg(coalesce("impressions"."amount", 0)) FROM "impressions"), 0) AS expected_amount
FROM "broadcasts"
LEFT OUTER JOIN "impressions" ON "impressions"."broadcast_id" = "broadcasts"."id"
GROUP BY "broadcasts"."id", "broadcasts"."title"
