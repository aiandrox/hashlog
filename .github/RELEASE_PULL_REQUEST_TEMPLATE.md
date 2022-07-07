Release <%= Time.now %>
@aiandrox 作業内容を確認してチェックをしてください。

---

<% pull_requests.each do |pr| -%>
<%=  pr.to_checklist_item %>
<% end -%>
