<div id="banlist">
	<table width="100%" cellspacing="0" cellpadding="0" align="center" class="listtable">
		<tr>
			<td width="5%" height="16" class="listtable_top" align="center"><b>游戏</b></td>
			<td width="10%" height="16" class="listtable_top" align="center"><b>日期</b></td>
			<td width="15%" height="16" class="listtable_top"><b><center>所在服务器</center></b></td>
			<td width="30%" height="16" class="listtable_top"><b><center>记录</center></b></td>
		</tr>
		{foreach from=$ban_list item=ban name=banlist}
			<tr class="tbl_out">
		<td height="16" align="center" class="listtable_1"><img src="images/games/csgo.png" alt="MOD" border="0" align="absmiddle"></td>
        <td height="16" align="center" class="listtable_1">{$ban.ban_date}</td>
        <td height="16" align="center" class="listtable_1">{$ban.player}</td>
        <td width="46%" height="16" align="center" class="listtable_1">{$ban.admin}</td>
			</tr>
		{/foreach}
	</table>
	<div id="banlist-nav"> 
        {$ban_nav}
    </div>
</div>
{literal}
<script type="text/javascript">window.addEvent('domready', function(){	
InitAccordion('tr.opener', 'div.opener', 'mainwrapper');
{/literal}
{literal}
}); 
</script>
{/literal}
