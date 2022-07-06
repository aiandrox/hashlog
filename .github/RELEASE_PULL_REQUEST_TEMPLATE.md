Release <%= Time.now %>
<% pull_requests.each do |pr| -%>
<%=  pr.to_checklist_item %>
<% end -%>

---

@aiandrox 作業内容を確認してください
