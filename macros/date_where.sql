{% macro date_where(table_suffix_field = '_TABLE_SUFFIX') %}
WHERE {{ table_suffix_field }} BETWEEN '{{ var("start_date")}}' AND '{{ var("end_date")}}'
{% endmacro %}