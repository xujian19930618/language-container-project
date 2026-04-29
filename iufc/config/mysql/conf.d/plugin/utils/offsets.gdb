set logging on
set width 0
define print_offset
  printf ", %d", (size_t)&(($arg0*)0)->$arg1
end
printf "{\"8.4.1\",\"cf8f21d589f7a83295329fd5cf4cc917\""
print_offset THD query_id
print_offset THD m_thread_id
print_offset THD m_main_security_ctx
print_offset THD m_command
print_offset THD lex
print_offset LEX comment
print_offset Security_context m_user
print_offset Security_context m_host
print_offset Security_context m_ip
print_offset Security_context m_priv_user
print_offset THD m_db
print_offset THD killed
print_offset THD m_protocol
print_offset PFS_thread m_session_connect_attrs
print_offset PFS_thread m_session_connect_attrs_length
print_offset PFS_thread m_session_connect_attrs_cs_number

print_offset THD net
print_offset LEX m_sql_cmd
print_offset Sql_cmd_uninstall_plugin m_comment
print_offset THD limit_found_rows
print_offset THD m_sent_row_count
print_offset THD m_row_count_func
printf ", 0"
printf ", 0"
printf ", 0"
printf ", 0"
printf "}"
